import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_view.dart';

@Deprecated('')
final taskViewProvider = Provider<List<TaskView>>(
  name: 'taskViewProvider',
  (ref) => throw UnimplementedError('Ensure to override taskViewProvider with a value'),
);

/// responsible to maintain the selected task view.
@Deprecated('')
final selectedTaskViewProvider = NotifierProvider<SelectedTaskView, TaskView>(
  name: 'selectedTaskViewProvider',
  () => throw UnimplementedError('Ensure to override selectedTaskViewProvider with a value'),
);

@Deprecated('')
class SelectedTaskView extends Notifier<TaskView> {
  @override
  TaskView build() {
    return ref.read(taskViewProvider).first;
  }

  void selectByIndex(int index) {
    final filters = ref.read(taskViewProvider);
    if (index >= 0 && index < filters.length) {
      final newState = filters[index];

      if (state != newState) state = newState;
    }
  }
}

/// A list of in-memory loaded task views.
/// What this means is that these task views were accessed and loaded in-memory for this app session.
@Deprecated('')
final loadedTaskViewsProvider = StateProvider<Set<TaskView>>((ref) {
  /// Update the controller state when the selected task view changes.
  /// Keep on adding the new selected task view to the controller state.
  ref.listen(
    selectedTaskViewProvider,
    (previous, next) => ref.controller.update((state) {
      if (state.contains(next)) return state;

      return {...state, next};
    }),
  );

  return {};
}, dependencies: [
  selectedTaskViewProvider,
]);

/// handles the page controller for task so we can navigate between task views
@Deprecated('')
final tasksPageControllerProvider = Provider<PageController>(
  (ref) => throw UnimplementedError('Ensure to override tasksPageControllerProvider with a value'),
  name: 'tasksPageControllerProvider',
);
