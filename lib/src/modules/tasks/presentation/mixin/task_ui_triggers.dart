import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/task_filter_provider.dart';
import '../state/tasks_provider.dart';

mixin TaskUiTriggersMixin {
  Future<void> addTask({required WidgetRef ref}) async {
    final _currentFilter = ref.read(selectedTaskFilterProvider);
    return ref.read(tasksProvider(_currentFilter).notifier).addTask();
  }
}
