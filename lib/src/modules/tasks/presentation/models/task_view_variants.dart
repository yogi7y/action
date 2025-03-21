import 'package:meta/meta.dart';

import '../../../filter/domain/entity/composite/and_filter.dart';
import '../../../filter/domain/entity/variants/select_filter.dart';
import '../../domain/entity/task_status.dart';
import 'task_filters.dart';
import 'task_view.dart';

@immutable
class StatusTaskView extends TaskView {
  StatusTaskView({
    required this.status,
    required super.ui,
    required super.id,
  }) : super(
          operations: TaskViewOperations(
            filter: AndFilter([const OrganizedFilter(), StatusFilter(status)]),
          ),
        );

  final TaskStatus status;
}

class ProjectTaskView extends TaskView {
  ProjectTaskView({
    required this.projectId,
    required super.ui,
    required super.id,
    this.status,
  }) : super(
          operations: TaskViewOperations(
            filter: AndFilter(
              [
                const OrganizedFilter(),
                ProjectFilter(projectId),
                if (status != null) StatusFilter(status),
              ],
            ),
          ),
        );

  final String projectId;
  final TaskStatus? status;
}

@immutable
class AllTasksView extends TaskView {
  const AllTasksView({
    required super.ui,
    required super.id,
  }) : super(operations: const TaskViewOperations(filter: SelectFilter()));
}

@immutable
class UnorganizedTaskView extends TaskView {
  const UnorganizedTaskView({
    required super.ui,
    required super.id,
  }) : super(
          operations: const TaskViewOperations(
            filter: OrganizedFilter(isOrganized: false),
          ),
        );
}
