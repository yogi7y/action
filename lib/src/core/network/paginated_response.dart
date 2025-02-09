import 'package:flutter/foundation.dart';

typedef Cursor = String;

/// A class representing a paginated response.
///
/// [T] is the type of the items in the results list.
@immutable
class PaginatedResponse<T> {
  /// Creates a new instance of [PaginatedResponse].
  ///
  /// [results] is the list of result.
  /// [total] is the total number of results available.
  const PaginatedResponse({
    required this.results,
    required this.total,
  });

  /// The list of result.
  final List<T> results;

  /// The total number of results available.
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
