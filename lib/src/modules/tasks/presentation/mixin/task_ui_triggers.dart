import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/new_task_provider.dart';
import '../state/task_view_provider.dart';
import '../state/tasks_provider.dart';

mixin TaskUiTriggersMixin {
  Future<void> addTask({
    required WidgetRef ref,
  }) async {
    final currentTaskView = ref.read(selectedTaskViewProvider);
    final task = ref.read(newTaskProvider);

    await ref.read(tasksNotifierProvider(currentTaskView).notifier).upsertTask(task);
  }
}
