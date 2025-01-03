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
    required this.animatedListKey,
    this.pageCount = 1,
  });

  final String label;
  final String icon;
  final GlobalKey<AnimatedListState> animatedListKey;
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
  AllTasksView({super.pageCount = 1})
      : super(
          label: 'All Tasks',
          icon: Assets.inbox,
          animatedListKey: GlobalKey(debugLabel: 'Animated list key All Tasks'),
        );

  @override
  TaskQuerySpecification toQuerySpecification() => const AllTasksSpecification();

  @override
  AllTasksView copyWithPage(PageCount pageCount) => AllTasksView(pageCount: pageCount);
}

final class StatusTaskView extends TaskView {
  StatusTaskView({
    required this.status,
    super.label = 'Status',
    super.icon = Assets.inbox,
    super.pageCount = 1,
  }) : super(
          animatedListKey: GlobalKey(debugLabel: 'Animated list key Status'),
        );

  final TaskStatus status;

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

final class OrganizedTaskView extends TaskView {
  OrganizedTaskView({
    required super.label,
    super.icon = Assets.inbox,
    this.isOrganized = false,
    this.isInInbox = false,
    super.pageCount = 1,
  }) : super(animatedListKey: GlobalKey(debugLabel: 'Animated list key Organized'));

  final bool isOrganized;
  final bool isInInbox;

  @override
  TaskQuerySpecification toQuerySpecification() => OrganizedTaskSpecification(
        isOrganized: isOrganized,
        isInInbox: isInInbox,
      );

  @override
  OrganizedTaskView copyWithPage(PageCount pageCount) => OrganizedTaskView(
        label: label,
        icon: icon,
        isOrganized: isOrganized,
        isInInbox: isInInbox,
        pageCount: pageCount,
      );
}
