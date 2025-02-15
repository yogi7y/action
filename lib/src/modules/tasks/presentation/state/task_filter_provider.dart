import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task_status.dart';
import '../models/task_view.dart';
import '../models/task_view_variants.dart';

final tasksFilterProvider = Provider<List<TaskView>>((ref) {
  return [
    StatusTaskView(status: TaskStatus.inProgress, ui: const TaskViewUI(label: 'In Progress')),
    StatusTaskView(status: TaskStatus.todo, ui: const TaskViewUI(label: 'Todo')),
    StatusTaskView(status: TaskStatus.done, ui: const TaskViewUI(label: 'Done')),
    const AllTasksView(ui: TaskViewUI(label: 'All')),
    const UnorganizedTaskView(ui: TaskViewUI(label: 'Unorganized')),
  ];
});

final selectedTaskView = NotifierProvider<SelectedTaskView, TaskView>(SelectedTaskView.new);

class SelectedTaskView extends Notifier<TaskView> {
  @override
  TaskView build() => ref.read(tasksFilterProvider).first;

  void selectByIndex(int index) {
    final filters = ref.read(tasksFilterProvider);
    if (index >= 0 && index < filters.length) {
      final newState = filters[index];

      if (state != newState) state = newState;
    }
  }
}

final tasksPageControllerProvider = Provider<PageController>((ref) {
  final controller = PageController();
  ref.onDispose(controller.dispose);
  return controller;
});
