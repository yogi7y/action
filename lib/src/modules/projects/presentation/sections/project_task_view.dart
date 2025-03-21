import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/router/routes.dart';
import '../../../tasks/domain/entity/task_status.dart';
import '../../../tasks/presentation/models/task_view.dart';
import '../../../tasks/presentation/models/task_view_variants.dart';
import '../../../tasks/presentation/screens/task_module.dart';
import '../state/project_detail_provider.dart';

class ProjectTaskViewWidget extends ConsumerWidget {
  const ProjectTaskViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const TaskModule();
  }
}

List<ProjectTaskView> projectTaskViews(String projectId) => <ProjectTaskView>[
      ProjectTaskView(
        projectId: projectId,
        status: TaskStatus.inProgress,
        ui: const TaskViewUI(label: AppStrings.inProgress),
        id: TaskView.generateId(
          screenName: AppRoute.projectDetail.name,
          viewName: AppStrings.inProgress.toLowerCase().replaceAll(' ', '_'),
        ),
      ),
      ProjectTaskView(
        projectId: projectId,
        status: TaskStatus.todo,
        ui: const TaskViewUI(label: AppStrings.todo),
        id: TaskView.generateId(
          screenName: AppRoute.projectDetail.name,
          viewName: AppStrings.todo.toLowerCase().replaceAll(' ', '_'),
        ),
      ),
      ProjectTaskView(
        projectId: projectId,
        status: TaskStatus.done,
        ui: const TaskViewUI(label: AppStrings.done),
        id: TaskView.generateId(
          screenName: AppRoute.projectDetail.name,
          viewName: AppStrings.done.toLowerCase().replaceAll(' ', '_'),
        ),
      ),
      ProjectTaskView(
        projectId: projectId,
        ui: const TaskViewUI(label: AppStrings.all),
        id: TaskView.generateId(
          screenName: AppRoute.projectDetail.name,
          viewName: AppStrings.all.toLowerCase().replaceAll(' ', '_'),
        ),
      ),
    ];
