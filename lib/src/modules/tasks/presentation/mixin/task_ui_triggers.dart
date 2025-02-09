import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin TaskUiTriggersMixin {
  Future<void> addTask({required WidgetRef ref}) async {
    throw UnimplementedError('');
    // final _currentFilter = ref.read(selectedTaskFilterProvider);
    // return ref.read(tasksProvider(_currentFilter).notifier).addTask();
  }
}
