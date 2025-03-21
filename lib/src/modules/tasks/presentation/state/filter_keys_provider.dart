import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_view.dart';

/// Provider that manages the GlobalKey state for task filters
final filterKeysProvider = NotifierProvider<FilterKeysNotifier, Map<TaskView, GlobalKey>>(
  name: 'filterKeysProvider',
  () => throw UnimplementedError('Ensure to override filterKeysProvider'),
);

class FilterKeysNotifier extends Notifier<Map<TaskView, GlobalKey>> {
  @override
  Map<TaskView, GlobalKey> build() => {};

  /// Initialize filter keys for a list of task views
  void initializeKeys(List<TaskView> taskViews) {
    final newKeys = <TaskView, GlobalKey>{};
    for (final filter in taskViews) {
      newKeys[filter] = GlobalKey();
    }
    state = newKeys;
  }

  /// Get the GlobalKey for a specific task view
  GlobalKey? getKey(TaskView taskView) => state[taskView];

  /// Get all filter views with their keys
  List<({TaskView filter, GlobalKey key})> getFilterViews() =>
      state.entries.map((entry) => (filter: entry.key, key: entry.value)).toList();
}
