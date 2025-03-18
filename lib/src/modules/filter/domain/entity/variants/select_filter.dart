import 'package:flutter/foundation.dart';

import '../filter.dart';
import '../filter_operations.dart';

/// A filter that represents a select operation.
///
/// This filter is used when you want to return a value as-is without any
/// modifications or transformations.
@immutable
class SelectFilter extends Filter {
  /// Creates a new [SelectFilter] instance.
  const SelectFilter();

  @override
  V accept<V>(FilterOperations<V> visitor) => visitor.visitSelect(this);
}
