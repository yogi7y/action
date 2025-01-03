import 'package:flutter/foundation.dart';

@immutable
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.results,
    required this.totalPages,
    required this.currentPage,
  });

  final List<T> results;
  final int totalPages;
  final int currentPage;

  @override
  bool operator ==(covariant PaginatedResponse<T> other) {
    if (identical(this, other)) return true;

    return other.results == results &&
        other.totalPages == totalPages &&
        other.currentPage == currentPage;
  }

  @override
  int get hashCode => results.hashCode ^ totalPages.hashCode ^ currentPage.hashCode;

  @override
  String toString() =>
      'PaginatedResponse(results: $results, totalPages: $totalPages, currentPage: $currentPage)';
}
