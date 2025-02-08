import 'package:flutter/foundation.dart';

import '../filter.dart';
import '../filter_visitor.dart';

@immutable
class EqualsFilter implements Filter<String> {
  const EqualsFilter({
    required this.key,
    required this.value,
  });

  @override
  final String key;

  @override
  final String value;

  @override
  T accept<T>(FilterOperations<T> visitor) => visitor.visitEquals(this);
}
