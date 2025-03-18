import 'package:flutter/foundation.dart';

import '../filter.dart';
import '../filter_operations.dart';

@immutable
class GreaterThanFilter extends PropertyFilter {
  const GreaterThanFilter({
    required super.key,
    required super.value,
  });

  @override
  V accept<V>(FilterOperations<V> visitor) => visitor.visitGreaterThan(this);
}
