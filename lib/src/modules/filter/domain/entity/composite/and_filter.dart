import 'package:flutter/foundation.dart';

import '../filter.dart';
import '../filter_operations.dart';
import 'composite_filter.dart';

/// A composite filter that combines multiple filters with logical AND.
///
/// All filters in the list must evaluate to true for the AND filter to be true.
/// ```dart
/// final complexFilter = AndFilter([
///   EqualsFilter(key: 'status', value: 'active'),
///   GreaterThanFilter(key: 'age', value: 18),
/// ]);
/// ```
@immutable
class AndFilter extends CompositeFilter {
  const AndFilter(List<Filter> filters) : super(filters: filters);

  @override
  V accept<V>(FilterOperations<V> visitor) => visitor.visitAnd(this);
}
