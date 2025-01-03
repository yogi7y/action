import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../domain/entity/task.dart';
import '../../domain/entity/task_view_type.dart';

typedef PageCount = int;

@immutable
sealed class TaskView {
  const TaskView({
    required this.label,
    required this.icon,
    this.status = TaskStatus.todo,
    this.pageCount = 1,
  });

  final String label;
  final String icon;
  final TaskStatus status;
  final PageCount pageCount;

  TaskQuerySpecification toQuerySpecification();

  TaskView copyWithPage(PageCount pageCount);

  TaskView incrementPage() => copyWithPage(pageCount + 1);

  TaskView resetPage() => copyWithPage(1);

  @override
  String toString() => 'TaskView(label: $label, icon: $icon, pageCount: $pageCount)';

  @override
  bool operator ==(covariant TaskView other) {
    if (identical(this, other)) return true;

    return other.label == label && other.icon == icon && other.pageCount == pageCount;
  }

  @override
  int get hashCode => label.hashCode ^ icon.hashCode ^ pageCount.hashCode;
}

final class AllTasksView extends TaskView {
  const AllTasksView({super.pageCount = 1})
      : super(
          label: 'All Tasks',
          icon: Assets.inbox,
        );

  @override
  TaskQuerySpecification toQuerySpecification() => const AllTasksSpecification();

  @override
  AllTasksView copyWithPage(PageCount pageCount) => AllTasksView(pageCount: pageCount);
}

final class StatusTaskView extends TaskView {
  const StatusTaskView({
    super.label = 'Status',
    super.icon = Assets.inbox,
    super.pageCount = 1,
    super.status,
  }) : super();

  @override
  TaskQuerySpecification toQuerySpecification() => StatusTaskSpecification(status);

  @override
  StatusTaskView copyWithPage(PageCount pageCount) => StatusTaskView(
        status: status,
        label: label,
        icon: icon,
        pageCount: pageCount,
      );
}

final class UnOrganizedTaskView extends TaskView {
  const UnOrganizedTaskView({
    required super.label,
    super.icon = Assets.inbox,
    super.pageCount = 1,
  }) : super();

  @override
  TaskQuerySpecification toQuerySpecification() =>
      const OrganizedTaskSpecification(isOrganized: false);

  @override
  UnOrganizedTaskView copyWithPage(PageCount pageCount) => UnOrganizedTaskView(
        label: label,
        icon: icon,
        pageCount: pageCount,
      );
}
