import 'package:flutter/material.dart';

import '../task_entity.dart';

abstract class Tasks {
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
}
