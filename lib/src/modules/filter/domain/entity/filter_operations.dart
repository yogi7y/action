import 'composite/and_filter.dart';
import 'composite/or_filter.dart';
import 'filter.dart';
import 'variants/equals_filter.dart';
import 'variants/greater_than_filter.dart';
import 'variants/select_filter.dart';

/// Visitor interface for implementing filter operations.
///
/// This visitor is used in conjunction with the [Filter] class to implement
/// the Visitor pattern for filter operations. Each concrete implementation of
/// this visitor can process filters differently based on the target platform
/// or use case.
///
/// The type parameter [V] represents the return type of the visitor methods.
/// For example, when implementing a database query builder, [V] might be a
/// query builder type.
///
/// ```dart
/// class DatabaseFilterOperations implements FilterOperations<QueryBuilder> {
///   @override
///   QueryBuilder visitEquals(EqualsFilter filter) {
///     return queryBuilder.equals(filter.key, filter.value);
///   }
/// }
///
abstract class FilterOperations<V> {
  /// Processes an equals filter operation.
  ///
  /// This method is called when visiting an [EqualsFilter] to process
  /// an equality comparison filter operation.
  ///
  /// [filter] The equals filter to process
  /// Returns a value of type [V] based on the visitor implementation
  V visitEquals(EqualsFilter filter);

  /// Processes a greater than filter operation.
  ///
  /// This method is called when visiting a [GreaterThanFilter] to process
  /// a greater than comparison filter operation.
  ///
  /// [filter] The greater than filter to process
  /// Returns a value of type [V] based on the visitor implementation
  V visitGreaterThan(GreaterThanFilter filter);

  /// Processes an AND filter operation.
  ///
  /// This method is called when visiting an [AndFilter] to process
  /// a logical AND operation between multiple filters.
  ///
  /// [filter] The AND filter to process
  /// Returns a value of type [V] based on the visitor implementation
  V visitAnd(AndFilter filter);

  /// Processes an OR filter operation.
  ///
  /// This method is called when visiting an [OrFilter] to process
  /// a logical OR operation between multiple filters.
  ///
  /// [filter] The OR filter to process
  /// Returns a value of type [V] based on the visitor implementation
  V visitOr(OrFilter filter);

  /// Processes a select filter operation.
  ///
  /// This method is called when visiting a [SelectFilter] to process
  /// a filter that returns the value as-is without modifications.
  ///
  /// [filter] The select filter to process
  /// Returns a value of type [V] based on the visitor implementation
  V visitSelect(SelectFilter filter);
}

/// Base class for implementing in-memory filter operations using the Visitor pattern.
///
/// [InMemoryFilterOperations] extends [FilterOperations] to provide in-memory filtering
/// capabilities for different entity types. It evaluates whether a specific entity
/// matches the given filter criteria.
///
/// The type parameter [T] represents the entity type being filtered.
/// For example, if you want to filter tasks, notes, or any other entity type.
///
/// Example implementation for Tasks:
/// ```dart
/// class TaskInMemoryFilterOperations extends InMemoryFilterOperations<Task> {
///   const TaskInMemoryFilterOperations(super.item);
///
///   @override
///   bool visitEquals(EqualsFilter filter) {
///     switch (filter.key) {
///       case 'status':
///         return item.status == filter.value;
///       case 'isOrganized':
///         return item.isOrganized == filter.value;
///       default:
///         throw ArgumentError('Unknown key: ${filter.key}');
///     }
///   }
/// }
/// ```
///
/// Usage:
/// ```dart
/// final task = Task(status: 'in_progress');
/// final filter = EqualsFilter<String>(key: 'status', value: 'in_progress');
/// final operations = TaskInMemoryFilterOperations(task);
/// final matches = filter.accept(operations); // Returns true
/// ```
abstract class InMemoryFilterOperations<T> implements FilterOperations<bool> {
  /// Creates a new instance of [InMemoryFilterOperations] for the given item.
  ///
  /// [item] is the entity instance that will be checked against filter criteria.
  const InMemoryFilterOperations(this.item);

  /// The entity instance to be evaluated against filter criteria.
  final T item;

  @override
  bool visitAnd(AndFilter filter) => filter.filters.every((f) => f.accept(this));

  @override
  bool visitOr(OrFilter filter) => filter.filters.any((f) => f.accept(this));

  @override
  bool visitSelect(SelectFilter filter) => true;
}
