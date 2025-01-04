// Add this record type at the top of the file
import 'package:collection/collection.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logger/logger.dart';
import '../../domain/entity/task.dart';
import '../models/task_view.dart';
import '../widgets/task_tile.dart';
import 'tasks_provider.dart';

class TaskMovementController {
  TaskMovementController();

  /// AnimatedList keys for each task view
  /// This is used to animate the list when adding a new task or removing a task.
  ///
  /// Added when the screen is visible.
  final _animatedListKeys = <String, GlobalKey<AnimatedListState>>{};

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

  /// Determines if a task should be shown in the current view before and after an update
  /// Returns a record containing:
  /// - wasInList: Whether the task was in the list before the update
  /// - shouldStayInList: Whether the task should remain in the list after the update
  /// - animatedListKey: The key that other providers can use to animate the task.
  List<TaskEntity> analyzeTaskMovement({
    required TaskEntity updatedTask,
    required int index,
    required List<TaskEntity> tasks,
    required TaskView currentView,
  }) {
    final tasksCopy = List<TaskEntity>.from(tasks);

    final existingTaskIndex = tasksCopy.indexWhere((task) => task.id == updatedTask.id);
    final _wasInList = existingTaskIndex != -1;
    final _shouldStayInList = currentView.canContainTask(updatedTask);
    try {
      final _animatedListKey = getAnimatedListKey(currentView.label);

      if (_wasInList && !_shouldStayInList) {
        // Remove the task from the list
        _removeItemFromAnimatedListAt(
          index: existingTaskIndex,
          animatedListKey: _animatedListKey,
          task: updatedTask,
        );
        tasksCopy.removeAt(index);
      } else if (!_wasInList && _shouldStayInList) {
        // Add the task to the list
        _animatedListKey.currentState?.insertItem(0);
        tasksCopy.insert(0, updatedTask);
      } else if (_wasInList && _shouldStayInList) {
        // Update the task in the list
        tasksCopy[existingTaskIndex] = updatedTask;
      }

      return tasksCopy;
    } catch (e, s) {
      logger(e.toString(), error: e, stackTrace: s);
      rethrow;
    }
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
          overrides: [scopedTaskProvider.overrideWithValue(task.withIndex(index))],
          child: const TaskTile(),
        ),
      ),
    );
  }
}

final taskMovementProvider = Provider<TaskMovementController>((ref) => TaskMovementController());
