import 'package:flutter/foundation.dart';

typedef Cursor = String;

@immutable
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.results,
  });

  final List<T> results;

  @override
  String toString() => 'PaginatedResponse(results: $results)';

  @override
  bool operator ==(covariant PaginatedResponse<T> other) {
    if (identical(this, other)) return true;

    return other.results == results;
  }

  @override
  int get hashCode => results.hashCode;
}
