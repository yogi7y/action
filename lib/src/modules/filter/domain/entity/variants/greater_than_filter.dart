import 'package:flutter/foundation.dart';

import '../filter.dart';
import '../filter_visitor.dart';

@immutable
class GreaterThanFilter implements Filter {
  const GreaterThanFilter({
    required this.key,
    required this.value,
  });

  @override
  final String key;

  @override
  final Object value;

  @override
  V accept<V>(FilterOperations<V> visitor) => visitor.visitGreaterThan(this);
}
