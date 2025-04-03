// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../core/pagination/pagination_strategy.dart';
import '../../../filter/domain/entity/filter.dart';
import '../../domain/entity/filters/task_filter_operations.dart';
import '../../domain/entity/task_entity.dart';

// ignore: flutter_style_todos
// todo: write unit tests for this.
/// Only includes [Filter] for equality and hashCode.
@immutable
class TaskListViewData {
  const TaskListViewData({
    required this.filter,
    required this.paginationStrategy,
  });

  final Filter filter;
  final PaginationStrategy paginationStrategy;

  bool canContainTask(TaskEntity task) {
    final inMemoryFilterOperations = InMemoryTaskFilterOperations(task);
    return filter.accept(inMemoryFilterOperations);
  }

  @override
  String toString() => 'TaskListViewArgs(filter: $filter, paginationStrategy: $paginationStrategy)';

  @override
  bool operator ==(covariant TaskListViewData other) {
    if (identical(this, other)) return true;

    return other.filter == filter;
  }

  @override
  int get hashCode => filter.hashCode;
}
