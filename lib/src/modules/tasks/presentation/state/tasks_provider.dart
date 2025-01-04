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
  late final _taskMovementProvider = ref.watch(taskMovementProvider);

  @override
  Future<List<TaskEntity>> build(TaskView arg) async => _fetchTasks(arg);

  Future<Tasks> _fetchTasks(TaskView arg) async {
    var _previousPageState = <TaskEntity>[];

    state = const AsyncLoading();

    if (arg.pageCount > 1) {
      _previousPageState =
          ref.read(tasksProvider(arg.copyWithPage(arg.pageCount - 1))).valueOrNull ?? [];
    }

    final _cursor =
        _previousPageState.isNotEmpty ? _previousPageState.last.createdAt.toIso8601String() : null;

    final result = await useCase.fetchTasks(
      arg.toQuerySpecification(),
      limit: TasksCountNotifier.limit,
      cursor: _cursor,
    );

    return result.fold(
      onSuccess: (paginatedResponse) => paginatedResponse.results,
      onFailure: (error) => throw error,
    );
  }

  GlobalKey<AnimatedListState> get _animatedListKey =>
      ref.read(taskMovementProvider).getAnimatedListKey(arg.label);

  Future<void> addTask() async {
    final _task = ref.read(newTaskProvider);

    final _previousState = state;

    const _id = '';
    final _createdAt = DateTime.now();
    final _updatedAt = _createdAt;
    final _tempTask = TaskEntity.fromTaskProperties(
      task: _task,
      createdAt: _createdAt,
      updatedAt: _updatedAt,
      id: _id,
    );

    state = AsyncData([_tempTask, ...state.valueOrNull ?? []]);
    _animatedListKey.currentState?.insertItem(0);
    _clearInput();

    try {
      final result = await useCase.createTask(_task);

      await result.fold(
        onSuccess: (task) async {
          final currentTasks = state.valueOrNull ?? [];

          final updatedTasks = currentTasks
              .map((taskItem) => taskItem.name == _tempTask.name ? task : taskItem)
              .toList();

          state = AsyncData(updatedTasks);
        },
        onFailure: (error) async {
          state = _previousState;
          throw error;
        },
      );
    } catch (e) {
      state = _previousState;
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
      _taskMovementProvider.analyzeTaskMovement(
        updatedTask: task,
        index: index,
        tasks: state.valueOrNull ?? [],
        currentView: arg,
      );

  @override
  FutureOr<Tasks> handleSuccessfulUpdate(TaskEntity updatedTask) {
    final currentTasks = state.valueOrNull ?? [];
    final updatedTasks = currentTasks
        .map((taskItem) => taskItem.id == updatedTask.id ? updatedTask : taskItem)
        .toList();

    return updatedTasks;
  }
}

typedef ScopedTaskWithIndex = ({int index, TaskEntity value});

extension TaskWithIndexExtension on TaskEntity {
  ScopedTaskWithIndex withIndex(int index) => (index: index, value: this);
}

final scopedTaskProvider = Provider<ScopedTaskWithIndex>(
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
