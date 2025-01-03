import 'package:core_y/core_y.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import '../mixin/tasks_operations_mixin.dart';
import '../models/task_view.dart';
import 'new_task_provider.dart';

final tasksProvider =
    AsyncNotifierProviderFamily<TasksNotifier, Tasks, TaskView>(TasksNotifier.new);

class TasksNotifier extends FamilyAsyncNotifier<Tasks, TaskView> with TaskOperationsMixin<Tasks> {
  /// AnimatedList keys for each task view
  /// This is used to animate the list when adding a new task or removing a task.
  ///
  /// Added when the screen is visible.
  final _animatedListKeys = <String, GlobalKey<AnimatedListState>>{};

  @override
  Future<List<TaskEntity>> build(TaskView arg) async => _fetchTasks(arg);

  Future<Tasks> _fetchTasks(TaskView arg) async {
    var _previousPageState = <TaskEntity>[];

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

  void addAnimatedListKey(String label, GlobalKey<AnimatedListState> key) {
    _animatedListKeys[label] = key;
  }

  GlobalKey<AnimatedListState> getAnimatedListKey(String label) {
    final _key = _animatedListKeys[label];

    if (_key == null)
      throw AppException(
        exception: 'AnimatedListKey not found for label: $label',
        stackTrace: StackTrace.current,
      );

    return _key;
  }

  GlobalKey<AnimatedListState> get _animatedListKey => getAnimatedListKey(arg.label);

  Future<void> addTask() async {
    final _task = ref.read(newTaskProvider);

    final _previousState = getState;

    const _id = '';
    final _createdAt = DateTime.now();
    final _updatedAt = _createdAt;
    final _tempTask = TaskEntity.fromTaskProperties(
      task: _task,
      createdAt: _createdAt,
      updatedAt: _updatedAt,
      id: _id,
    );

    getState = AsyncData([_tempTask, ...getState.valueOrNull ?? []]);
    _animatedListKey.currentState?.insertItem(0);
    _clearInput();

    try {
      final result = await useCase.createTask(_task);

      await result.fold(
        onSuccess: (task) async {
          final currentTasks = getState.valueOrNull ?? [];

          final updatedTasks = currentTasks
              .map((taskItem) => taskItem.name == _tempTask.name ? task : taskItem)
              .toList();

          getState = AsyncData(updatedTasks);
        },
        onFailure: (error) async {
          getState = _previousState;
          throw error;
        },
      );
    } catch (e) {
      getState = _previousState;
      rethrow;
    } finally {
      ref.invalidate(newTaskProvider);
    }
  }

  void _clearInput() => ref.read(newTaskProvider.notifier).clear();

  @override
  Future<AsyncValue<Tasks>> handleOptimisticUpdate(TaskEntity task) async {
    return AsyncData(
      getState.valueOrNull?.map((taskItem) {
            return taskItem.id == task.id ? task : taskItem;
          }).toList() ??
          [],
    );
  }

  @override
  Future<AsyncValue<Tasks>> handleOptimisticDelete(TaskId id) async => AsyncData(
        getState.valueOrNull?.where((task) => task.id != id).toList() ?? [],
      );

  @override
  Future<AsyncValue<Tasks>> handleSuccessfulUpdate(TaskEntity updatedTask) async {
    final currentTasks = getState.valueOrNull ?? [];
    final updatedTasks = currentTasks
        .map((taskItem) => taskItem.id == updatedTask.id ? updatedTask : taskItem)
        .toList();
    return AsyncData(updatedTasks);
  }

  @override
  Future<AsyncValue<Tasks>> handleSuccessfulDelete(TaskId id) async => AsyncData(
        getState.valueOrNull?.where((task) => task.id != id).toList() ?? [],
      );

  @override
  TaskUseCase get useCase => ref.read(taskUseCaseProvider);
}

final scopedTaskProvider = Provider<TaskEntity>(
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
