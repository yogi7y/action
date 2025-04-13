import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../task_entity.dart';
import 'tasks.dart';

@immutable
class TasksList extends DelegatingList<TaskEntity> implements TasksOperations {
  const TasksList(super.base);

  /// todo: write unit test.
  factory TasksList.fromList(List<TaskEntity> list) => TasksList(list);

  /// Creates an empty [TasksList].
  factory TasksList.empty() => const TasksList([]);

  @override
  int getInsertIndex(TaskEntity task) {
    var left = 0;
    var right = length;

    while (left < right) {
      final mid = left + (right - left) ~/ 2;

      // For descending order: if the task at mid is newer than or equal to the new task,
      // search in the right half, otherwise search in the left half
      if (this[mid].createdAt!.isAfter(task.createdAt!) ||
          this[mid].createdAt!.isAtSameMomentAs(task.createdAt!)) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }

    return left;
  }

  @override
  int indexOfTask(TaskEntity task) => super.indexWhere(
        (e) => ((e.id ?? '').isNotEmpty && (task.id ?? '').isNotEmpty)
            ? e.id == task.id
            : (e.name.toLowerCase() == task.name.toLowerCase()),
      );

  @override
  void insertTask(int index, TaskEntity task) => super.insert(index, task);

  @override
  void insertTaskAtStart(TaskEntity task) => super.insert(0, task);
}

extension PrimitiveTaskListExtension on List<TaskEntity> {
  /// todo: write unit test.
  TasksList toTasksList() => TasksList(this);
}
