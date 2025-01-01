// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../domain/entity/task.dart';
import '../../domain/entity/task_view_type.dart';

@immutable
abstract class TaskView {
  const TaskView({
    required this.label,
    required this.icon,
    required this.animatedListKey,
  });

  final String label;
  final String icon;
  final GlobalKey<AnimatedListState> animatedListKey;

  TaskQuerySpecification toQuerySpecification();

  @override
  String toString() => 'TaskView(label: $label, icon: $icon)';

  @override
  bool operator ==(covariant TaskView other) {
    if (identical(this, other)) return true;

    return other.label == label && other.icon == icon;
  }

  @override
  int get hashCode => label.hashCode ^ icon.hashCode;
}

@immutable
class AllTasksView extends TaskView {
  AllTasksView()
      : super(
          label: 'All Tasks',
          icon: Assets.inbox,
          animatedListKey: GlobalKey(debugLabel: 'Animated list key All Tasks'),
        );

  @override
  TaskQuerySpecification toQuerySpecification() => const AllTasksSpecification();
}

class StatusTaskView extends TaskView {
  StatusTaskView({
    required this.status,
    super.label = 'Status',
    super.icon = Assets.inbox,
  }) : super(
          animatedListKey: GlobalKey(debugLabel: 'Animated list key Status'),
        );

  final TaskStatus status;

  @override
  TaskQuerySpecification toQuerySpecification() => StatusTaskSpecification(status);
}

class OrganizedTaskView extends TaskView {
  OrganizedTaskView({
    required super.label,
    super.icon = Assets.inbox,
    this.isOrganized = false,
    this.isInInbox = false,
  }) : super(animatedListKey: GlobalKey(debugLabel: 'Animated list key Organized'));

  final bool isOrganized;
  final bool isInInbox;

  @override
  TaskQuerySpecification toQuerySpecification() => OrganizedTaskSpecification(
        isOrganized: isOrganized,
        isInInbox: isInInbox,
      );
}
