import 'package:flutter/foundation.dart';

import '../filter.dart';
import '../filter_operations.dart';

@immutable
class EqualsFilter extends PropertyFilter {
  const EqualsFilter({
    required super.key,
    required super.value,
  });

  @override
  V accept<V>(FilterOperations<V> visitor) => visitor.visitEquals(this);
}
