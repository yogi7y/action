import 'package:collection/collection.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logger/logger.dart';
import '../../domain/entity/task.dart';
import '../models/task_view.dart';
import '../widgets/task_tile.dart';
import 'scoped_task_provider.dart';
import 'task_view_provider.dart';
import 'tasks_provider.dart';
import 'tasks_provider_old.dart';

class TaskMovementController {
  TaskMovementController({
    required this.allTaskViews,
    required this.ref,
  });

  final List<TaskView> allTaskViews;
  final Ref ref;

  /// AnimatedList keys for each task view
  /// This is used to animate the list when adding a new task or removing a task.
  ///
  /// Added when the screen is visible.
  final _animatedListKeys = <String, GlobalKey<AnimatedListState>>{};

  /// There might be cases where the user has not visited a view yet, hence its data is not loaded in memory.
  /// In such cases, we can probably skip the check for that view to ensure we don't load unnecessary data.
  /// When the user visits the view, latest data will be fetched anyway.
  final _loadedViews = <TaskView>[];

  void addAnimatedListKey(String label, GlobalKey<AnimatedListState> key) {
    throw UnimplementedError('');
    // _animatedListKeys[label] = key;
    // final view = allTaskViews.firstWhereOrNull((view) => view.label == label);

    // if (view == null)
    //   throw AppException(
    //     exception: 'TaskView not found for label: $label',
    //     stackTrace: StackTrace.current,
    //   );

    // _loadedViews.add(view);
  }

  GlobalKey<AnimatedListState> getAnimatedListKey(String label) {
    final key = _animatedListKeys[label];

    if (key == null)
      throw AppException(
        exception: 'AnimatedListKey not found for label: $label',
        stackTrace: StackTrace.current,
      );

    return key;
  }

  /// 1. Detect if the task belongs in the current list.
  /// 2. Accordingly update/insert/remove the task from the list.
  /// 3. Check if the task belongs to other loaded lists and update them accordingly.
  ///
  /// To detect if a task belongs to a list:
  /// - The task.
  /// - Active view.
  /// - index
  /// - key

  List<TaskEntity> _updateTaskInList({
    required TaskEntity task,
    required int index,
    required TaskView currentView,
    required List<TaskEntity> tasks,
    VoidCallback? onRemove,
    VoidCallback? onAdd,
  }) {
    throw UnimplementedError('');
    // final tasksCopy = List<TaskEntity>.from(tasks);

    // final taskExistsInList = tasksCopy.indexWhere((element) => element.id == task.id) != -1;
    // final taskBelongsToList = currentView.canContainTask(task);

    // /// if the task exists in the current list, but no longer belong to it after the update, remove it.
    // if (taskExistsInList && !taskBelongsToList) {
    //   tasksCopy.removeAt(index);
    //   onRemove?.call();
    // }

    // /// if the task doesn't exist in the current list, but belongs to it after the update, add it.
    // else if (!taskExistsInList && taskBelongsToList) {
    //   tasksCopy.insert(0, task);
    //   onAdd?.call();
    // }

    // /// if the task exists in the current list and still belongs to it after the update, update it.
    // else if (taskExistsInList && taskBelongsToList) {
    //   tasksCopy[index] = task;
    // }

    // return tasksCopy;
  }

  /// The function that the clients will call.
  /// Returns the updated list of tasks for the current view.
  List<TaskEntity> updateTaskInList({
    required TaskEntity task,
    required int index,
    required TaskView currentView,
    required List<TaskEntity> tasks,
  }) {
    throw UnimplementedError('');
    // final updatedTasksListForCurrentView = _updateTaskInList(
    //   task: task,
    //   index: index,
    //   currentView: currentView,
    //   tasks: tasks,
    //   onRemove: () => _removeItemFromAnimatedListAt(
    //     index: index,
    //     animatedListKey: getAnimatedListKey(currentView.label),
    //     task: task,
    //   ),
    //   onAdd: () => getAnimatedListKey(currentView.label).currentState?.insertItem(0),
    // );

    // for (final view in _loadedViews) {
    //   if (!view.canContainTask(task)) continue;
    //   if (view.label == currentView.label) continue;

    //   final tasks0 = ref.read(tasksProvider(view)).valueOrNull ?? [];
    //   final index0 = tasks0.indexWhere((element) => element.id == task.id);

    //   _updateTaskInList(
    //     task: task,
    //     index: index0 == -1 ? 0 : index0,
    //     currentView: view,
    //     tasks: tasks0,
    //     onRemove: () {
    //       ref.read(tasksProvider(view).notifier).removeTaskFromMemory(
    //             taskId: task.id,
    //             index: index0,
    //           );
    //       _removeItemFromAnimatedListAt(
    //         index: 0,
    //         animatedListKey: getAnimatedListKey(view.label),
    //         task: task,
    //       );
    //     },
    //     onAdd: () {
    //       ref.read(tasksProvider(view).notifier).insertTaskInMemory(task);
    //       getAnimatedListKey(view.label).currentState?.insertItem(0);
    //     },
    //   );
    // }

    // return updatedTasksListForCurrentView;
  }

  List<TaskEntity> analyzeTaskMovement({
    required TaskEntity updatedTask,
    required int index,
    required List<TaskEntity> tasks,
    required TaskView currentView,
    required Ref ref,
  }) {
    throw UnimplementedError('');
    // final tasksCopy = List<TaskEntity>.from(tasks);

    // final existingTaskIndex = tasksCopy.indexWhere((task) => task.id == updatedTask.id);
    // final wasInList = existingTaskIndex != -1;
    // final shouldStayInList = currentView.canContainTask(updatedTask);
    // try {
    //   final animatedListKey = getAnimatedListKey(currentView.label);

    //   if (wasInList && !shouldStayInList) {
    //     // Remove the task from the list
    //     _removeItemFromAnimatedListAt(
    //       index: existingTaskIndex,
    //       animatedListKey: animatedListKey,
    //       task: updatedTask,
    //     );
    //     tasksCopy.removeAt(index);
    //   } else if (!wasInList && shouldStayInList) {
    //     // Add the task to the list
    //     animatedListKey.currentState?.insertItem(0);
    //     tasksCopy.insert(0, updatedTask);
    //   } else if (wasInList && shouldStayInList) {
    //     // Update the task in the list
    //     tasksCopy[existingTaskIndex] = updatedTask;
    //   }

    //   return tasksCopy;
    // } catch (e, s) {
    //   logger(e.toString(), error: e, stackTrace: s);
    //   rethrow;
    // }
  }

  void _removeItemFromAnimatedListAt({
    required int index,
    required GlobalKey<AnimatedListState> animatedListKey,
    required TaskEntity task,
  }) {
    animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        axisAlignment: -1, // Align to top to animate bottom-up
        child: ProviderScope(
          overrides: [scopedTaskProvider.overrideWithValue((index: index, task: task))],
          child: const TaskTile(),
        ),
      ),
    );
  }
}

final taskMovementProvider = Provider<TaskMovementController>(
  (ref) => TaskMovementController(
    allTaskViews: ref.read(taskViewProvider),
    ref: ref,
  ),
);
