import 'package:flutter/material.dart';

import '../../../filter/domain/entity/filter.dart';

/// Combination of things like [Filter] and [TaskViewUI], etc. combining which
/// a task view will be eventually shown.
@immutable
class TaskView {
  const TaskView({
    required this.operations,
    required this.ui,
  });

  final TaskViewOperations operations;
  final TaskViewUI ui;

  @override
  String toString() => 'TaskView(operations: $operations, ui: $ui)';

  @override
  bool operator ==(covariant TaskView other) {
    if (identical(this, other)) return true;

    return other.operations == operations && other.ui == ui;
  }

  @override
  int get hashCode => operations.hashCode ^ ui.hashCode;
}

/// [TaskViewUI] is to hold some UI properties like what label to show, what icon to show, etc.
@immutable
class TaskViewUI {
  const TaskViewUI({
    required this.label,
    this.icon,
  });
  final String label;
  final IconData? icon;

  @override
  String toString() => 'TaskViewUi(label: $label, icon: $icon)';

  @override
  bool operator ==(covariant TaskViewUI other) {
    if (identical(this, other)) return true;

    return other.label == label && other.icon == icon;
  }

  @override
  int get hashCode => label.hashCode ^ icon.hashCode;
}

/// [TaskViewOperations] is a combination of things like [Filter] and sort.
/// Anything that can decide which all tasks should be visible.
@immutable
class TaskViewOperations {
  const TaskViewOperations({
    required this.filter,
  });

  final Filter filter;

  @override
  String toString() => 'TaskViewOperations(filter: $filter)';

  @override
  bool operator ==(covariant TaskViewOperations other) {
    if (identical(this, other)) return true;

    return other.filter == filter;
  }

  @override
  int get hashCode => filter.hashCode;
}
