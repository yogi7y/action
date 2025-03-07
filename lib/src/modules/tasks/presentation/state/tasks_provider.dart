import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/task_entity.dart';
import '../../domain/entity/task_status.dart';
import '../../domain/use_case/task_use_case.dart';
import '../models/task_view.dart';
import 'new_task_provider.dart';
import 'task_view_provider.dart';

final tasksNotifierProvider =
    AsyncNotifierProviderFamily<TasksNotifier, List<TaskEntity>, TaskView>(TasksNotifier.new);

/// [TasksNotifier] is a notifier that contains the list of tasks.
///
/// It should be overridden wherever the tasks are needed.
/// It is responsible to handle listing, pagination, updating state etc for a list of tasks.
/// It acts like a common module for all the task views through the app.
class TasksNotifier extends FamilyAsyncNotifier<List<TaskEntity>, TaskView> {
  late final useCase = ref.read(taskUseCaseProvider);
  late final _loadedTaskViews = ref.read(loadedTaskViewsProvider);

  /// Animated list key for the current task view.
  ///
  /// Used to animate the list of tasks when a task is added or removed.
  late GlobalKey<AnimatedListState> _animatedListKey;

  // ignore: use_setters_to_change_properties
  void setAnimatedListKey(GlobalKey<AnimatedListState> key) => _animatedListKey = key;

  @nonVirtual
  GlobalKey<AnimatedListState>? get animatedListKey => _animatedListKey;

  @override
  Future<List<TaskEntity>> build(TaskView arg) async => _fetchTasks();

  Future<List<TaskEntity>> _fetchTasks() async {
    final result = await useCase.fetchTasks(arg.operations.filter);

    return result.fold(
      onSuccess: (tasksResult) => tasksResult.results,
      onFailure: (failure) => <TaskEntity>[],
    );
  }

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

      return await upsertTask(
        updatedItem,
        previousStateArg: previousState,
      );
    } catch (e) {
      state = AsyncData(previousState ?? []);
    }
  }

  Future<void> upsertTask(
    TaskEntity task, {
    /// Whether to add the task to the top of the list.
    /// Mark this as true if you're creating a new task.
    /// Should be `false` when updating an existing task.
    bool addToTop = false,

    /// The previous state of the tasks.
    /// Used to revert the state in case of failure.
    /// If not provided, the current state will be used.
    List<TaskEntity>? previousStateArg,
  }) async {
    final previousState = previousStateArg ?? state.valueOrNull;

    final now = DateTime.now();

    final tempOptimisticTask = task.copyWith(
      createdAt: task.createdAt ?? now,
      updatedAt: now,
    );

    // Move task to respective views based on the current state + Optimistic update.
    _moveTaskToRespectiveView(tempOptimisticTask);

    /// Hide the text field after the task is successfully added.
    ref.read(isTaskTextInputFieldVisibleProvider.notifier).state = false;

    final result = await useCase.upsertTask(task);

    result.fold(
      onSuccess: (taskResult) {
        // TODO: [Performance] maybe rather than iterating over the entire list, we can do some
        // optimization as mostly the task will be at the top of the list.

        /// The temp optimistic task which we saved in the previous step.
        bool isOptimisticTask(TaskEntity task) =>
            task.id == null && task.name == tempOptimisticTask.name;

        state = AsyncData(
          state.valueOrNull?.map((e) => isOptimisticTask(e) ? taskResult : e).toList() ?? [],
        );
      },
      onFailure: (failure) {
        state = AsyncData(previousState ?? []);
      },
    );
  }

  /// Add a task in memory.
  /// Does not make any API calls or anything, just update the state in memory.
  void addInMemoryTask(
    TaskEntity task, {
    /// Uses the passed in task view to update the task to.
    /// In case not provided, the task will be added to the current task view.
    TaskView? taskView,
  }) {
    final taskViewToUse = taskView ?? arg;
    final taskViewNotifier = ref.read(tasksNotifierProvider(taskViewToUse).notifier);

    final tasks = taskViewToUse == arg
        ? (state.valueOrNull ?? [])
        : (ref.read(tasksNotifierProvider(taskViewToUse)).valueOrNull ?? []).toList();

    final index = useCase.getInsertIndexForTask(tasks, task);

    /// If task is same, then it probably means that the task already exists and we just need to update it.
    /// todo: need some handling.
    if (tasks[index].id == task.id) {
      removeIfTaskExists(task);
    }

    tasks.insert(index, task);

    taskViewNotifier.updateState(tasks);

    final animatedListKeyForTaskView =
        ref.read(tasksNotifierProvider(taskViewToUse).notifier).animatedListKey;

    animatedListKeyForTaskView?.currentState?.insertItem(index);
  }

  /// Remove a task in memory.
  /// Does not make any API calls or anything, just update the state in memory.
  void removeIfTaskExists(
    TaskEntity task, {
    /// Uses the passed in task view to update the task to.
    /// In case not provided, the task will be removed from the current task view.
    TaskView? taskView,
  }) {
    final taskViewToUse = taskView ?? arg;
    final taskViewNotifier = ref.read(tasksNotifierProvider(taskViewToUse).notifier);

    final tasks = taskViewToUse == arg
        ? (state.valueOrNull ?? [])
        : (ref.read(tasksNotifierProvider(taskViewToUse)).valueOrNull ?? []).toList();

    final index = tasks.indexOf(task);
    if (index == -1) return;

    tasks.removeAt(index);

    taskViewNotifier.updateState(tasks);

    final animatedListKeyForTaskView =
        ref.read(tasksNotifierProvider(taskViewToUse).notifier).animatedListKey;

    animatedListKeyForTaskView?.currentState?.removeItem(index, (_, __) => Container());
  }

  /// After a task is updated, check in which all views it should be added/removed.
  /// For eg, if a task is currently in todo view and user completes it,
  /// it should be removed from the todo view and should be added in the done view.
  void _moveTaskToRespectiveView(TaskEntity task) {
    for (final view in _loadedTaskViews) {
      if (view.canContainTask(task)) {
        addInMemoryTask(task, taskView: view);
      } else {
        removeIfTaskExists(task, taskView: view);
      }
    }
  }

  @visibleForTesting
  void updateState(List<TaskEntity> newState) => state = AsyncData(newState);
}
