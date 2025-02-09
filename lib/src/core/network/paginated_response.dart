import 'package:flutter/foundation.dart';

typedef Cursor = String;

@immutable
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.results,
    required this.total,
  });

  final List<T> results;
  final int total;

  @override
  String toString() => 'PaginatedResponse(results: $results, total: $total)';

  @override
  bool operator ==(covariant PaginatedResponse<T> other) {
    if (identical(this, other)) return true;

    return other.results == results && other.total == total;
  }

  @override
  int get hashCode => results.hashCode ^ total.hashCode;
}
