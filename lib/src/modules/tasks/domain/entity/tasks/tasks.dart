import 'package:flutter/material.dart';

import '../task_entity.dart';

@immutable
abstract class TasksOperations {
  /// Insert a task at a given index.
  void insertTask(int index, TaskEntity task);

  /// method to insert a task at the start of the list
  void insertTaskAtStart(TaskEntity task);

  /// get index of a task.
  /// returns -1 if the task is not found
  int indexOfTask(TaskEntity task);

  /// get index of where the new task should be inserted.
  int getInsertIndex(TaskEntity task);
}
