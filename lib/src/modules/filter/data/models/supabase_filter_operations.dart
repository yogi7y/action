// coverage:ignore-file
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/composite/and_filter.dart';
import '../../domain/entity/composite/or_filter.dart';
import '../../domain/entity/filter_operations.dart';
import '../../domain/entity/variants/equals_filter.dart';
import '../../domain/entity/variants/greater_than_filter.dart';
import '../../domain/entity/variants/not_filter.dart';
import '../../domain/entity/variants/nullable_filter.dart';
import '../../domain/entity/variants/select_filter.dart';

class SupabaseFilterOperations<T> implements FilterOperations<PostgrestFilterBuilder<T>> {
  const SupabaseFilterOperations(this.query);

  final PostgrestFilterBuilder<T> query;

  @override
  PostgrestFilterBuilder<T> visitEquals(EqualsFilter filter) => query.eq(filter.key, filter.value!);

  @override
  PostgrestFilterBuilder<T> visitGreaterThan(GreaterThanFilter filter) =>
      query.gt(filter.key, filter.value!);

  @override
  PostgrestFilterBuilder<T> visitSelect(SelectFilter filter) => query;

  @override
  PostgrestFilterBuilder<T> visitAnd(AndFilter filter) =>
      filter.filters.fold(query, (q, f) => f.accept(SupabaseFilterOperations(q)));

  @override
  PostgrestFilterBuilder<T> visitOr(OrFilter filter) {
    if (filter.filters.isEmpty) return query;

    // Start with the first filter
    var result = filter.filters.first.accept(SupabaseFilterOperations(query));

    // Add OR conditions for remaining filters
    for (final f in filter.filters.skip(1)) {
      result = result.or('${f.accept(SupabaseFilterOperations(query))}');
    }

    return result;
  }

  @override
  PostgrestFilterBuilder<T> visitNullable(NullableFilter filter) {
    throw UnimplementedError();
  }

  @override
  PostgrestFilterBuilder<T> visitNot(NotFilter filter) {
    throw UnimplementedError();
  }
}
