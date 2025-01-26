import 'dart:async';

import 'package:core_y/core_y.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import '../mixin/tasks_operations_mixin.dart';
import '../models/task_view.dart';
import 'new_task_provider.dart';
import 'task_movement.dart';

final tasksProvider =
    AsyncNotifierProviderFamily<TasksNotifier, Tasks, TaskView>(TasksNotifier.new);

class TasksNotifier extends FamilyAsyncNotifier<Tasks, TaskView>
    with BaseTaskOperationsMixin<Tasks>, FamilyAsyncTaskOperationsMixin<Tasks, TaskView> {
  @override
  Future<List<TaskEntity>> build(TaskView arg) async => _fetchTasks(arg);

  Future<Tasks> _fetchTasks(TaskView arg) async {
    var previousPageState = <TaskEntity>[];

    state = const AsyncLoading();

    if (arg.pageCount > 1) {
      previousPageState =
          ref.read(tasksProvider(arg.copyWithPage(arg.pageCount - 1))).valueOrNull ?? [];
    }

    final cursor =
        previousPageState.isNotEmpty ? previousPageState.last.createdAt.toIso8601String() : null;

    final result = await useCase.fetchTasks(
      arg.toQuerySpecification(),
      limit: TasksCountNotifier.limit,
      cursor: cursor,
    );

    return result.fold(
      onSuccess: (paginatedResponse) => paginatedResponse.results,
      onFailure: (error) => throw error,
    );
  }

  GlobalKey<AnimatedListState> get _animatedListKey =>
      ref.read(taskMovementProvider).getAnimatedListKey(arg.label);

  Future<void> addTask() async {
    final task = ref.read(newTaskProvider);

    final previousState = state;

    const id = '';
    final createdAt = DateTime.now();
    final updatedAt = createdAt;
    final tempTask = TaskEntity.fromTaskProperties(
      task: task,
      createdAt: createdAt,
      updatedAt: updatedAt,
      id: id,
    );

    state = AsyncData([tempTask, ...state.valueOrNull ?? []]);
    _animatedListKey.currentState?.insertItem(0);
    _clearInput();

    try {
      final result = await useCase.createTask(task);

      await result.fold(
        onSuccess: (task) async {
          final currentTasks = state.valueOrNull ?? [];

          final updatedTasks = currentTasks
              .map((taskItem) => taskItem.name == tempTask.name ? task : taskItem)
              .toList();

          state = AsyncData(updatedTasks);
        },
        onFailure: (error) async {
          state = previousState;
          throw error;
        },
      );
    } catch (e) {
      state = previousState;
      rethrow;
    } finally {
      ref.invalidate(newTaskProvider);
    }
  }

  void _clearInput() => ref.read(newTaskProvider.notifier).clear();

  @override
  TaskUseCase get useCase => ref.read(taskUseCaseProvider);

  /// todo: needs optimization here.
  /// currently we're making a O(n) operation to update the task in the list. Let's target to make it O(1).
  @override
  Tasks handleOptimisticUpdate(TaskEntity task, int index) =>
      ref.watch(taskMovementProvider).updateTaskInList(
            task: task,
            index: index,
            currentView: arg,
            tasks: state.valueOrNull ?? [],
          );

  /// Inserts a task into the in-memory task list without performing any API operations.
  ///
  /// This method prepends the given [task] to the current list of tasks stored in state.
  /// Note: This is a memory-only operation and does not persist changes to any backend/storage.
  ///
  /// [task] The task entity to be inserted at the beginning of the task list.
  void insertTaskInMemory(TaskEntity task) =>
      state = AsyncData([task, ...(state.valueOrNull ?? [])]);

  /// Removes a task from in-memory without performing any API operations.
  ///
  /// This method removes the given task from the current list of tasks stored in state.
  /// Note: This is a memory-only operation and does not persist changes to any backend/storage.
  ///
  /// [taskId] The ID of the task to be removed. Only used for validation.
  /// [index] The index of the task to be removed from the task list.
  void removeTaskFromMemory({
    required String taskId,
    required int index,
  }) {
    final tasks = state.valueOrNull ?? [];

    if (index < 0 || index >= tasks.length) {
      throw AppException(
        exception: 'Index out of bounds',
        stackTrace: StackTrace.current,
      );
    }

    if (tasks[index].id != taskId) {
      throw AppException(
        exception: 'Task ID mismatch at the specified index',
        stackTrace: StackTrace.current,
      );
    }

    final updatedTasks = List<TaskEntity>.from(tasks)..removeAt(index);
    state = AsyncData(updatedTasks);
  }

  @override
  FutureOr<Tasks> handleSuccessfulUpdate(TaskEntity updatedTask) {
    final currentTasks = state.valueOrNull ?? [];
    final updatedTasks = currentTasks
        .map((taskItem) => taskItem.id == updatedTask.id ? updatedTask : taskItem)
        .toList();

    return updatedTasks;
  }
}

typedef WithIndex<T> = ({int index, T value});

extension TaskWithIndexExtension on TaskEntity {
  WithIndex<TaskEntity> withIndex(int index) => (index: index, value: this);
}

final scopedTaskProvider = Provider<WithIndex<TaskEntity>>(
    (ref) => throw UnimplementedError('Ensure to override scopedTaskProvider'));

final tasksCountNotifierProvider =
    AsyncNotifierProviderFamily<TasksCountNotifier, int, TaskView>(TasksCountNotifier.new);

class TasksCountNotifier extends FamilyAsyncNotifier<int, TaskView> {
  static const limit = 20;

  @override
  Future<int> build(TaskView arg) async {
    final result = await ref.watch(taskUseCaseProvider).getTotalTasks(arg.toQuerySpecification());

    return result.fold(
      onSuccess: (count) => count,
      onFailure: (error) => throw error,
    );
  }

  void increment() {
    state = AsyncData(state.value! + 1);
  }

  void decrement() {
    state = AsyncData(state.value! - 1);
  }
}
