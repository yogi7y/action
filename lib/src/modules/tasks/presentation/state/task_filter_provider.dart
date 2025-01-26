import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task_status.dart';
import '../models/task_view.dart';

final tasksFilterProvider = Provider<List<TaskView>>((ref) {
  return [
    const StatusTaskView(status: TaskStatus.inProgress, label: 'In Progress'),
    const StatusTaskView(label: 'Todo'),
    const StatusTaskView(label: 'Done', status: TaskStatus.done),
    const AllTasksView(),
    const UnOrganizedTaskView(label: 'Unorganized'),
  ];
});

final selectedTaskFilterProvider =
    NotifierProvider<SelectedTaskFilterNotifier, TaskView>(SelectedTaskFilterNotifier.new);

class SelectedTaskFilterNotifier extends Notifier<TaskView> {
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
