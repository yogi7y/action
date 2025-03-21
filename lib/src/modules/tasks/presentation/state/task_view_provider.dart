import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_view.dart';

final taskViewProvider = Provider<List<TaskView>>(
  name: 'taskViewProvider',
  (ref) => throw UnimplementedError('Ensure to override taskViewProvider with a value'),
  // (ref) => [
  //   StatusTaskView(
  //     status: TaskStatus.inProgress,
  //     ui: const TaskViewUI(label: 'In Progress'),
  //     id: TaskView.generateId(
  //       screenName: 'tasks_screen',
  //       viewName: 'in_progress_tasks_view',
  //     ),
  //   ),
  //   StatusTaskView(
  //     status: TaskStatus.todo,
  //     ui: const TaskViewUI(label: 'Todo'),
  //     id: TaskView.generateId(
  //       screenName: 'tasks_screen',
  //       viewName: 'todo_tasks_view',
  //     ),
  //   ),
  //   StatusTaskView(
  //     status: TaskStatus.done,
  //     ui: const TaskViewUI(label: 'Done'),
  //     id: TaskView.generateId(
  //       screenName: 'tasks_screen',
  //       viewName: 'done_tasks_view',
  //     ),
  //   ),
  //   AllTasksView(
  //     ui: const TaskViewUI(label: 'All'),
  //     id: TaskView.generateId(
  //       screenName: 'tasks_screen',
  //       viewName: 'all_tasks_view',
  //     ),
  //   ),
  //   UnorganizedTaskView(
  //     ui: const TaskViewUI(label: 'Unorganized'),
  //     id: TaskView.generateId(
  //       screenName: 'tasks_screen',
  //       viewName: 'unorganized_tasks_view',
  //     ),
  //   ),
  // ],
);

/// responsible to maintain the selected task view.
final selectedTaskViewProvider = NotifierProvider<SelectedTaskView, TaskView>(
  name: 'selectedTaskViewProvider',
  () => throw UnimplementedError('Ensure to override selectedTaskViewProvider with a value'),
);

class SelectedTaskView extends Notifier<TaskView> {
  @override
  TaskView build() => ref.read(taskViewProvider).first;

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
final tasksPageControllerProvider = Provider<PageController>(
  (ref) => throw UnimplementedError('Ensure to override tasksPageControllerProvider with a value'),
  name: 'tasksPageControllerProvider',
);
