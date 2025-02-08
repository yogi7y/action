import 'package:flutter/foundation.dart';

import 'filter_visitor.dart';

/// Base class for implementing filter criteria using the Visitor pattern.
///
/// [Filter] is used to define filtering conditions that can be applied to data queries.
/// It uses the Visitor pattern through [FilterOperations] to allow different implementations
/// of filter operations.
///
/// The type parameter [T] represents the type of the filter value.
/// For example, if you want to filter a string, boolean, number, etc.
///
/// ```dart
/// final allOrganizedTasks = EqualsFilter<bool>(key: 'isOrganized', value: true);
/// ```
///
/// If you want to filter a string, you can do the following:
/// ```dart
///  final allTasksForJohn = EqualsFilter<String>(key: 'assignee', value: 'John');
/// ```
@immutable
abstract class Filter<T> {
  /// Creates a new filter with the specified [key] and [value].
  ///
  /// [key] represents the field or property to filter on.
  /// [value] represents the value to filter by, of type [T].
  const Filter({
    required this.key,
    required this.value,
  });

  /// The field or property name to filter on.
  final String key;

  /// The value to filter by.
  final T value;

  /// Accepts a visitor to implement the specific filter operation.
  ///
  /// This method is part of the Visitor pattern implementation.
  /// [visitor] is the [FilterOperations] that will process this filter.
  /// Returns a value of type [V] as determined by the visitor implementation.
  V accept<V>(FilterOperations<V> visitor);
}
