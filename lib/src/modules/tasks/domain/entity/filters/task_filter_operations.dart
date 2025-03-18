import 'package:flutter/foundation.dart';

import '../../../../../core/exceptions/in_memory_filter_exception.dart';
import '../../../../filter/domain/entity/filter_operations.dart';
import '../../../../filter/domain/entity/variants/equals_filter.dart';
import '../../../../filter/domain/entity/variants/greater_than_filter.dart';
import '../../../../filter/domain/entity/variants/not_filter.dart';
import '../../../../filter/domain/entity/variants/nullable_filter.dart';
import '../task_entity.dart';
import '../task_status.dart';

@immutable
class InMemoryTaskFilterOperations extends InMemoryFilterOperations<TaskEntity> {
  const InMemoryTaskFilterOperations(super.item);

  static const statusKey = 'status';

  static const dueDateKey = 'due_date';

  static const isOrganizedKey = 'is_organized';

  static const idKey = 'id';

  static const titleKey = 'name';

  static const descriptionKey = 'description';

  static const createdAtKey = 'created_at';

  static const updatedAtKey = 'updated_at';

  static const projectIdKey = 'project_id';

  static const contextIdKey = 'context_id';

  @override
  bool visitEquals(EqualsFilter filter) {
    final (key, value) = (filter.key, filter.value);

    return switch ((key, value)) {
      (statusKey, final String value) => item.status == TaskStatus.fromString(value),
      (isOrganizedKey, final bool value) => item.computedIsOrganized == value,
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

  @override
  bool visitNullable(NullableFilter filter) {
    final (key, value) = (filter.key, filter.value);

    return switch ((key, value)) {
      (projectIdKey, null) => item.projectId == null,
      (contextIdKey, null) => item.contextId == null,
      (_, _) => throw InMemoryFilterException(
          key: key,
          value: value,
          stackTrace: StackTrace.current,
        ),
    };
  }

  @override
  bool visitNot(NotFilter filter) => !filter.filter.accept(this);
}
