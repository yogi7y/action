import 'package:flutter/foundation.dart';

import 'filter_operations.dart';

/// Base class for all filters in the system.
///
/// This is the root of the filter hierarchy that supports both
/// property-based filters (like equals, greater than) and composite
/// filters (like AND, OR).
@immutable
abstract class Filter {
  const Filter();

  /// Accepts a visitor to implement the specific filter operation.
  ///
  /// This method is part of the Visitor pattern implementation.
  /// [visitor] is the [FilterOperations] that will process this filter.
  /// Returns a value of type [V] as determined by the visitor implementation.
  V accept<V>(FilterOperations<V> visitor);
}

/// Base class for implementing property-based filter criteria.
///
/// [PropertyFilter] is used to define filtering conditions that operate on a specific
/// property/field with a value. Examples include equals, greater than, less than, etc.
///
/// The filter value is of type [Object] to support filtering on any value type
/// like strings, booleans, numbers, etc.
///
/// ```dart
/// final allOrganizedTasks = EqualsFilter(key: 'isOrganized', value: true);
/// ```
///
/// If you want to filter a string, you can do the following:
/// ```dart
///  final allTasksForJohn = EqualsFilter(key: 'assignee', value: 'John');
/// ```
@immutable
abstract class PropertyFilter extends Filter {
  /// Creates a new property filter with the specified [key] and [value].
  ///
  /// [key] represents the field or property to filter on.
  /// [value] represents the value to filter by, of type [Object].
  const PropertyFilter({
    required this.key,
    required this.value,
  });

  /// The field or property name to filter on.
  final String key;

  /// The value to filter by.
  final Object value;
}
