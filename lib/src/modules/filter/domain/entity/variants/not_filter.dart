import 'package:meta/meta.dart';

import '../filter.dart';
import '../filter_operations.dart';

/// A filter that negates the result of another filter.
///
/// This filter implements logical NOT operation on any other filter.
/// It can be used to invert the results of any existing filter.
///
/// ```dart
/// // Find all unorganized tasks by negating the OrganizedFilter
/// final unorganizedTasks = NotFilter(OrganizedFilter());
///
/// // Find all tasks that are neither done nor discarded
/// final activeTasksFilter = NotFilter(
///   OrFilter([
///     StatusFilter(TaskStatus.done),
///     StatusFilter(TaskStatus.discard),
///   ])
/// );
/// ```
@immutable
class NotFilter extends Filter {
  /// Creates a new NOT filter that negates the given [filter].
  ///
  /// [filter] is the filter whose result should be negated.
  const NotFilter(this.filter);

  /// The filter to negate.
  final Filter filter;

  @override
  V accept<V>(FilterOperations<V> visitor) => visitor.visitNot(this);

  @override
  String toString() => 'NotFilter(filter: $filter)';

  @override
  bool operator ==(covariant Filter other) {
    if (identical(this, other)) return true;
    return other is NotFilter && other.filter == filter;
  }

  @override
  int get hashCode => filter.hashCode;
}
