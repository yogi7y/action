import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/header/app_header.dart';
import '../../domain/entity/task_status.dart';
import '../mixin/task_module_scope.dart';
import '../models/task_view.dart';
import '../models/task_view_variants.dart';
import 'task_module.dart';

class TaskScreen extends ConsumerWidget with TaskModuleScope {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(title: 'Tasks'),
          SizedBox(height: spacing.xxs),
          ProviderScope(
            overrides: [
              ...createTaskModuleScope(TaskModuleData(
                taskViews: taskViews,
                isSliver: true,
              )),
            ],
            child: const Expanded(child: TaskModule()),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
final taskViews = [
  StatusTaskView(
    status: TaskStatus.inProgress,
    ui: const TaskViewUI(label: 'In Progress'),
    id: TaskView.generateId(
      screenName: 'tasks_screen',
      viewName: 'in_progress_tasks_view',
    ),
  ),
  StatusTaskView(
    status: TaskStatus.todo,
    ui: const TaskViewUI(label: 'Todo'),
    id: TaskView.generateId(
      screenName: 'tasks_screen',
      viewName: 'todo_tasks_view',
    ),
  ),
  StatusTaskView(
    status: TaskStatus.done,
    ui: const TaskViewUI(label: 'Done'),
    id: TaskView.generateId(
      screenName: 'tasks_screen',
      viewName: 'done_tasks_view',
    ),
  ),
  AllTasksView(
    ui: const TaskViewUI(label: 'All'),
    id: TaskView.generateId(
      screenName: 'tasks_screen',
      viewName: 'all_tasks_view',
    ),
  ),
  UnorganizedTaskView(
    ui: const TaskViewUI(label: 'Unorganized'),
    id: TaskView.generateId(
      screenName: 'tasks_screen',
      viewName: 'unorganized_tasks_view',
    ),
  ),
];
