import 'package:meta/meta.dart';

import '../task_entity.dart';
import 'tasks.dart';

class TasksList extends Tasks {
  TasksList(List<TaskEntity> tasks) : _tasks = tasks;

  final List<TaskEntity> _tasks;

  @override
  int getInsertIndex(TaskEntity task) {
    var left = 0;
    var right = _tasks.length;

    while (left < right) {
      final mid = left + (right - left) ~/ 2;

      // For descending order: if the task at mid is newer than or equal to the new task,
      // search in the right half, otherwise search in the left half
      if (_tasks[mid].createdAt!.isAfter(task.createdAt!) ||
          _tasks[mid].createdAt!.isAtSameMomentAs(task.createdAt!)) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }

    return left;
  }

  @override
  int indexOf(TaskEntity task) => _tasks.indexWhere(
        (e) => ((e.id ?? '').isNotEmpty && (task.id ?? '').isNotEmpty)
            ? e.id == task.id
            : (e.name.toLowerCase() == task.name.toLowerCase()),
      );

  @override
  void insert(int index, TaskEntity task) => _tasks.insert(index, task);

  @override
  void insertAtStart(TaskEntity task) => _tasks.insert(0, task);

  @override
  @visibleForTesting
  Iterable<TaskEntity> get value => _tasks;

  @override
  Iterator<TaskEntity> get iterator => _tasks.iterator;

  @override
  Tasks copyWith(Iterable<TaskEntity> Function(Iterable<TaskEntity> currentTasks) callback) {
    final newTasks = callback(_tasks).toList();
    return TasksList(newTasks);
  }
}

void main(List<String> args) {
  final tasks = TasksList([]);
}
