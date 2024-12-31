import '../../../../design_system/design_system.dart';
import '../../domain/entity/task.dart';
import '../../domain/entity/task_view_type.dart';

abstract class TaskView {
  const TaskView({
    required this.label,
    required this.icon,
  });

  final String label;
  final String icon;

  TaskQuerySpecification toQuerySpecification();
}

class AllTasksView extends TaskView {
  const AllTasksView()
      : super(
          label: 'All Tasks',
          icon: Assets.inbox,
        );

  @override
  TaskQuerySpecification toQuerySpecification() => const AllTasksSpecification();
}

class StatusTaskView extends TaskView {
  const StatusTaskView({
    required this.status,
    super.label = 'Status',
    super.icon = Assets.inbox,
  });

  final TaskStatus status;

  @override
  TaskQuerySpecification toQuerySpecification() => StatusTaskSpecification(status);
}

class OrganizedTaskView extends TaskView {
  const OrganizedTaskView({
    required super.label,
    required super.icon,
    this.isOrganized = true,
    this.isInInbox = false,
  });

  final bool isOrganized;
  final bool isInInbox;

  @override
  TaskQuerySpecification toQuerySpecification() => OrganizedTaskSpecification(
        isOrganized: isOrganized,
        isInInbox: isInInbox,
      );
}
