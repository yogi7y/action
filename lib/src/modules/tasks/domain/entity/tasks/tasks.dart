import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../task_entity.dart';

@immutable
abstract class Tasks extends Iterable<TaskEntity> {
  /// Returns all the tasks.
  @visibleForTesting
  Iterable<TaskEntity> get value;

  /// Insert a task at a given index.
  void insert(int index, TaskEntity task);

  /// method to insert a task at the start of the list
  void insertAtStart(TaskEntity task);

  /// get index of a task.
  /// returns -1 if the task is not found
  int indexOf(TaskEntity task);

  /// get index of where the new task should be inserted.
  int getInsertIndex(TaskEntity task);

  /// Creates a new instance of Tasks with modified task list.
  /// The callback receives the current tasks and should return a new list of tasks.
  Tasks copyWith(Iterable<TaskEntity> Function(Iterable<TaskEntity> currentTasks) callback);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Tasks) return false;

    return const IterableEquality<TaskEntity>().equals(value, other.value);
  }

  @override
  int get hashCode => const IterableEquality<TaskEntity>().hash(value);
}
