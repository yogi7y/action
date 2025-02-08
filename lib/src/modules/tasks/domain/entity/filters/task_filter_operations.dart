import 'package:flutter/foundation.dart';

import '../../../../../core/exceptions/in_memory_filter_exception.dart';
import '../../../../filter/domain/entity/filter_visitor.dart';
import '../../../../filter/domain/entity/variants/equals_filter.dart';
import '../../../../filter/domain/entity/variants/greater_than_filter.dart';
import '../task.dart';
import '../task_status.dart';

@immutable
class InMemoryTaskFilterOperations extends InMemoryFilterOperations<TaskEntity> {
  const InMemoryTaskFilterOperations(super.item);

  @visibleForTesting
  static const statusKey = 'status';

  @visibleForTesting
  static const dueDateKey = 'due_date';

  @visibleForTesting
  static const isOrganizedKey = 'is_organized';

  @visibleForTesting
  static const idKey = 'id';

  @visibleForTesting
  static const titleKey = 'name';

  @visibleForTesting
  static const descriptionKey = 'description';

  @visibleForTesting
  static const createdAtKey = 'created_at';

  @visibleForTesting
  static const updatedAtKey = 'updated_at';

  @visibleForTesting
  static const projectIdKey = 'project_id';

  @visibleForTesting
  static const contextIdKey = 'context_id';

  @override
  bool visitEquals(EqualsFilter filter) {
    final (key, value) = (filter.key, filter.value);

    return switch ((key, value)) {
      (statusKey, final String value) => item.status == TaskStatus.fromString(value),
      (isOrganizedKey, final bool value) => item.isOrganized == value,
      (projectIdKey, final String value) => item.projectId == value,
      (contextIdKey, final String value) => item.contextId == value,
      (idKey, final String value) => item.id == value,
      (_, _) => throw InMemoryFilterException(
          key: key,
          value: value,
          stackTrace: StackTrace.current,
        ),
    };
  }

  @override
  bool visitGreaterThan(GreaterThanFilter filter) {
    final (key, value) = (filter.key, filter.value);

    return switch ((key, value)) {
      (dueDateKey, final DateTime value) => item.dueDate != null && item.dueDate!.isAfter(value),
      (_, _) => throw InMemoryFilterException(
          key: key,
          value: value,
          stackTrace: StackTrace.current,
        ),
    };
  }
}
