import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/filter_visitor.dart';
import '../../domain/entity/variants/equals_filter.dart';

class SupabaseFilterVisitor<T> implements FilterOperations<PostgrestFilterBuilder<T>> {
  const SupabaseFilterVisitor(this.query);

  final PostgrestFilterBuilder<T> query;

  @override
  PostgrestFilterBuilder<T> visitEquals(EqualsFilter filter) => query.eq(filter.key, filter.value);
}
