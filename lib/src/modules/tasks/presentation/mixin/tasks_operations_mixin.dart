import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../state/new_task_provider.dart';
import '../state/tasks_provider.dart';

mixin TasksOperations {
  Future<void> addTask({
    required WidgetRef ref,
  }) async {
    final _taskNotifier = ref.watch(tasksProvider.notifier);
    final _taskName = ref.watch(newTaskProvider);

    final _taskProperties = TaskPropertiesEntity(
      name: _taskName.name,
      status: TaskStatus.todo,
    );

    await _taskNotifier.addTask(_taskProperties);
  }
}
