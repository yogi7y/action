// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

const defaultLimit = 50;
const defaultOffset = 0;

/// Abstract class defining pagination strategy for data fetching.
@immutable
abstract class PaginationStrategy {
  /// Creates a new instance of [PaginationStrategy].
  const PaginationStrategy({
    this.limit = defaultLimit,
  });

  /// The maximum number of items to fetch per request.
  /// If set to 0, it indicates no limit (fetch all items).
  final int limit;
}

/// Strategy for offset-based pagination.
@immutable
class OffsetPaginationStrategy extends PaginationStrategy {
  /// Creates a new instance of [OffsetPaginationStrategy].
  const OffsetPaginationStrategy({
    super.limit,
    this.offset = defaultOffset,
  });

  /// The number of items to skip from the beginning.
  final int offset;

  OffsetPaginationStrategy copyWith({
    int? limit,
    int? offset,
  }) =>
      OffsetPaginationStrategy(
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
      );

  @override
  String toString() => 'OffsetPaginationStrategy(limit: $limit, offset: $offset)';

  @override
  bool operator ==(covariant OffsetPaginationStrategy other) {
    if (identical(this, other)) return true;

    return other.limit == limit && other.offset == offset;
  }

  @override
  int get hashCode => limit.hashCode ^ offset.hashCode;
}

/// Strategy for fetching all items or a limited set without pagination.
@immutable
class NoPaginationStrategy extends PaginationStrategy {
  /// Creates a new instance of [NoPaginationStrategy].
  ///
  /// If [limit] is 0, all items will be fetched.
  /// If [limit] is greater than 0, only that many items will be fetched.
  const NoPaginationStrategy({
    super.limit,
  });

  /// Whether this strategy should fetch all items.
  bool get fetchAll => limit == 0;

  NoPaginationStrategy copyWith({
    int? limit,
  }) =>
      NoPaginationStrategy(
        limit: limit ?? this.limit,
      );

  @override
  String toString() => 'NoPaginationStrategy(limit: $limit)';

  @override
  bool operator ==(covariant NoPaginationStrategy other) {
    if (identical(this, other)) return true;

    return other.limit == limit;
  }

  @override
  int get hashCode => limit.hashCode;
}

/// Strategy for fetching all items without pagination.
class FetchAllPaginationStrategy extends NoPaginationStrategy {
  const FetchAllPaginationStrategy({super.limit = 0});
}
