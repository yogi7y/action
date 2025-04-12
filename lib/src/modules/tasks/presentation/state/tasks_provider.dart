// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/task_entity.dart';
import '../../domain/entity/task_status.dart';
import '../../domain/use_case/task_use_case.dart';
import '../models/task_list_view_data.dart';
import 'loaded_task_view_provider.dart';

final tasksProvider =
    AsyncNotifierProviderFamily<TasksNotifier, List<TaskEntity>, TaskListViewData>(
  TasksNotifier.new,
  name: 'tasksProvider',
);

/// Responsible for the CRUD operations on tasks list.
/// Is a family and a single source of point of all the tasks list within an app session.
/// Also updates the updated task in memory and decides which all views it should be added/removed from.
class TasksNotifier extends FamilyAsyncNotifier<List<TaskEntity>, TaskListViewData> {
  late final useCase = ref.read(taskUseCaseProvider);

  /// Animated list key for the current task view.
  ///
  /// Used to animate the list of tasks when a task is added or removed.
  late GlobalKey<AnimatedListState> _animatedListKey;

  // ignore: use_setters_to_change_properties
  void setAnimatedListKey(GlobalKey<AnimatedListState> key) => _animatedListKey = key;

  @nonVirtual
  GlobalKey<AnimatedListState>? get animatedListKey => _animatedListKey;

  @override
  Future<List<TaskEntity>> build(TaskListViewData arg) async {
    /// adding the current view to loaded task provider to indicate that it's loaded in memory.
    /// added a delay to avoid rebuilding the provider during the build.
    Future<void>.delayed(
      Duration.zero,
      () => ref.read(loadedTaskListViewDataProvider.notifier).update((state) => {...state, arg}),
    );

    return _fetchTasks();
  }

  Future<List<TaskEntity>> _fetchTasks() async {
    final result = await useCase.fetchTasks(arg.filter);

    return result.fold(
      onSuccess: (tasksResult) => tasksResult.results,
      onFailure: (failure) => <TaskEntity>[],
    );
  }

  @Deprecated('use upsertTask instead')
  Future<void> toggleCheckbox(int index, TaskStatus status) async {
    final previousState = state.valueOrNull?.toList();
    try {
      final tempOptimisticTask = state.valueOrNull ?? [];

      final item = tempOptimisticTask[index];

      final updatedItem = item.copyWith(status: status);

      tempOptimisticTask
        ..removeAt(index)
        ..insert(index, updatedItem);

      state = AsyncData(tempOptimisticTask);

      return await upsertTask(updatedItem);
    } catch (e) {
      state = AsyncData(previousState ?? []);
    }
  }

  /// Add/Update a task.
  /// The task state should be handled by the client. upsertTask will just take in the updated state and apply the same as optimistic update.
  Future<void> upsertTask(TaskEntity task) async {
    /// The previous state of the tasks.
    final previousState = state.valueOrNull;

    /// Check in which all the task views the task should be added/updated.
    handleInMemoryTask(task);

    final result = await useCase.upsertTask(task);

    result.fold(
      onSuccess: (taskResult) {
        // replace the temp optimistic task with the actual task.

        final updatedTasks = state.valueOrNull?.mapIndexed((index, element) {
              final handleTask = (element.id == taskResult.id) ||
                  (element.id == null && taskResult.id != null && element.name == taskResult.name);

              if (handleTask) {
                handleInMemoryTask(taskResult);
                return taskResult;
              } else {
                return element;
              }
            }).toList() ??
            [];

        state = AsyncData(updatedTasks);
      },
      onFailure: (failure) {
        state = AsyncData(previousState ?? []);
      },
    );
  }

  void handleInMemoryTask(
    TaskEntity task, {
    /// Will reduce any lookup and make the computation faster by directly accessing the element
    /// at the given index.
    ///
    /// If not provided, a lookup will be performed to find the index of the task.
    int? index,
  }) {
    final loadedTaskViews = ref.read(loadedTaskListViewDataProvider);

    for (final view in loadedTaskViews) {
      if (view.canContainTask(task)) {
        addOrUpdateTask(task, taskListViewData: view, index: index);
      } else {
        removeIfTaskExists(task, taskListViewData: view, index: index);
      }
    }
  }

  /// Add a task in memory.
  /// Does not make any API calls or anything, just update the state in memory.
  void addOrUpdateTask(
    TaskEntity task, {
    /// Uses the passed in task view to update the task to.
    /// In case not provided, the task will be added to the current task view.
    required TaskListViewData taskListViewData,

    /// Whether to animate the task addition/removal.
    /// Defaults to true.
    /// Mostly will be set to false when updating a task which will stay in place.
    bool animate = true,

    /// The index of the task to add/update.
    /// In case not provided, the task will be added to the current task view
    /// by searching for the task in the list.
    int? index,
  }) {
    final tasks = _getTasksForView(taskListViewData);
    final _index = index ?? _findTaskIndex(tasks, task);
    final isNewTask = _index == -1;

    if (isNewTask) {
      final insertAtIndex = getInsertIndexForTask(tasks, task);
      tasks.insert(insertAtIndex, task);
      _updateTaskViewState(taskListViewData, tasks);
      _animateTaskInsertion(insertAtIndex, taskListViewData, animate);
    } else {
      // Update the task at the existing index
      tasks[_index] = task;
      _updateTaskViewState(taskListViewData, tasks);
    }
  }

  /// Animate the insertion of a task into the list
  void _animateTaskInsertion(int index, TaskListViewData taskView, bool animate) {
    final animatedListKeyForTaskView = ref.read(tasksProvider(taskView).notifier).animatedListKey;

    animatedListKeyForTaskView?.currentState?.insertItem(
      index,
      duration: animate ? _defaultDuration : Duration.zero,
    );
  }

  /// Remove a task in memory.
  /// Does not make any API calls or anything, just update the state in memory.
  void removeIfTaskExists(
    TaskEntity task, {
    /// Uses the passed in task view to update the task to.
    /// In case not provided, the task will be removed from the current task view.
    required TaskListViewData taskListViewData,

    /// The index of the task to remove.
    /// In case not provided, the task will be removed from the current task view
    /// by searching for the task in the list.
    int? index,

    /// Whether to animate the task addition/removal.
    /// Defaults to true.
    /// Mostly will be set to false when updating a task which will stay in place.
    bool animate = true,
  }) {
    final tasks = _getTasksForView(taskListViewData);

    final _index = index ?? _findTaskIndex(tasks, task);

    if (_index == -1) return;

    tasks.removeAt(_index);

    _updateTaskViewState(taskListViewData, tasks);
    _animateTaskRemoval(_index, taskListViewData, animate);
  }

  /// Get the current tasks list for a specific view
  List<TaskEntity> _getTasksForView(TaskListViewData taskListViewData) {
    return taskListViewData == arg
        ? (state.valueOrNull ?? []).toList()
        : (ref.read(tasksProvider(taskListViewData)).valueOrNull ?? []).toList();
  }

  /// Find the index of a task in a list
  int _findTaskIndex(List<TaskEntity> tasks, TaskEntity task) => tasks.indexWhere(
        (e) => ((e.id ?? '').isNotEmpty && (task.id ?? '').isNotEmpty)
            ? e.id == task.id
            : (e.name.toLowerCase() == task.name.toLowerCase()),
      );

  /// Update the state of a task view
  void _updateTaskViewState(TaskListViewData taskListViewData, List<TaskEntity> tasks) {
    ref.read(tasksProvider(taskListViewData).notifier).updateState(tasks);
  }

  /// Animate the removal of a task from the list
  void _animateTaskRemoval(int index, TaskListViewData taskListViewData, bool animate) {
    final animatedListKeyForTaskView =
        ref.read(tasksProvider(taskListViewData).notifier).animatedListKey;

    animatedListKeyForTaskView?.currentState?.removeItem(
      index,
      (_, __) => Container(),
      duration: animate ? _defaultDuration : Duration.zero,
    );
  }

  final _defaultDuration = const Duration(milliseconds: 300);

  /// Returns the index at which a new task should be inserted to maintain
  /// descending order by createdAt (newest tasks at the top).
  int getInsertIndexForTask(List<TaskEntity> tasks, TaskEntity task) {
    var left = 0;
    var right = tasks.length;

    while (left < right) {
      final mid = left + (right - left) ~/ 2;

      // For descending order: if the task at mid is newer than or equal to the new task,
      // search in the right half, otherwise search in the left half
      if (tasks[mid].createdAt!.isAfter(task.createdAt!) ||
          tasks[mid].createdAt!.isAtSameMomentAs(task.createdAt!)) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }

    return left;
  }

  @visibleForTesting
  void updateState(List<TaskEntity> newState) => state = AsyncData(newState);
}
