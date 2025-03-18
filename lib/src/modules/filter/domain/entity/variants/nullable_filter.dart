import 'package:flutter/foundation.dart';

import '../filter.dart';
import '../filter_operations.dart';

/// A filter that checks if a property is null or non-null.
///
/// This filter can be used to find entities where a specific property
/// is either null or non-null, based on the [isNull] parameter.
///
/// ```dart
/// // Find all tasks where assignee is null
/// final unassignedTasks = NullableFilter(key: 'assignee', checkForNull: true);
///
/// // Find all tasks where assignee is not null
/// final assignedTasks = NullableFilter(key: 'assignee', checkForNull: false);
/// ```
@immutable
class NullableFilter extends PropertyFilter {
  /// Creates a new nullable filter for the specified [key].
  ///
  /// [key] is the property to check for null/non-null.
  /// [isNull] determines whether to match null values (true) or non-null values (false).
  const NullableFilter({
    required super.key,
    required this.isNull,
  }) : super(value: '');

  /// Whether to check for null values (true) or non-null values (false).
  final bool isNull;

  @override
  V accept<V>(FilterOperations<V> visitor) => visitor.visitNullable(this);

  @override
  String toString() => 'NullableFilter(key: $key, checkForNull: $isNull)';

  @override
  bool operator ==(covariant Filter other) {
    if (identical(this, other)) return true;

    return other is NullableFilter && other.key == key && other.isNull == isNull;
  }

  @override
  int get hashCode => Object.hash(key, isNull);
}
