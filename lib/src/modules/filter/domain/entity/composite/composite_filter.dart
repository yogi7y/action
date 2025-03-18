// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../filter.dart';

/// Base class for composite filters that combine multiple filters.
///
/// This class serves as the base for filters like AND and OR that operate on
/// a collection of other filters. It implements the Composite pattern, allowing
/// filters to be combined into tree structures.
@immutable
abstract class CompositeFilter extends Filter {
  const CompositeFilter({
    required this.filters,
  });

  /// The list of filters to be combined.
  final List<Filter> filters;

  @override
  String toString() => 'CompositeFilter(filters: $filters)';

  @override
  bool operator ==(covariant Filter other) {
    if (identical(this, other)) return true;

    return other is CompositeFilter && listEquals(other.filters, filters);
  }

  @override
  int get hashCode => filters.hashCode;
}
