// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../filter/domain/entity/filter.dart';
import '../../domain/entity/filters/task_filter_operations.dart';
import '../../domain/entity/task_entity.dart';

/// Combination of things like [Filter] and [TaskViewUI], etc. combining which
/// a task view will be eventually shown.
@immutable
class TaskView {
  const TaskView({
    required this.operations,
    required this.ui,
    required this.id,
  });

  /// [operations] is to hold the operations like [Filter] and sort.
  final TaskViewOperations operations;

  /// [ui] is to hold the UI properties like what label to show, what icon to show, etc.
  final TaskViewUI ui;

  bool canContainTask(TaskEntity task) {
    final inMemoryFilterOperations = InMemoryTaskFilterOperations(task);
    return operations.filter.accept(inMemoryFilterOperations);
  }

  /// Unique identifier for a task view.
  /// Can be used to uniquely identify a task view.
  ///
  /// Naming can be like the screen where it's being shown + the name of the view.
  /// For example: `tasks_screen_all_tasks_view`, `tasks_screen_unorganized_tasks_view`, etc.
  final String id;

  /// Used to generate a unique identifier for a task view.
  /// Helper method to create [id] for a task view.
  static String generateId({
    required String screenName,
    required String viewName,
  }) =>
      '${screenName}_$viewName';

  @override
  String toString() => 'TaskView(operations: $operations, ui: $ui, id: $id)';

  @override
  bool operator ==(covariant TaskView other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
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
