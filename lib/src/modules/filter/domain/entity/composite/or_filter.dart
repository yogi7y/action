import 'package:flutter/foundation.dart';

import '../filter.dart';
import '../filter_operations.dart';
import 'composite_filter.dart';

/// A composite filter that combines multiple filters with logical OR.
///
/// At least one filter in the list must evaluate to true for the OR filter to be true.
/// ```dart
/// final complexFilter = OrFilter([
///   EqualsFilter(key: 'status', value: 'active'),
///   EqualsFilter(key: 'status', value: 'pending'),
/// ]);
/// ```
@immutable
class OrFilter extends CompositeFilter {
  const OrFilter(List<Filter> filters) : super(filters: filters);

  @override
  V accept<V>(FilterOperations<V> visitor) => visitor.visitOr(this);
}
