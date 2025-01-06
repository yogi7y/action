import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../../services/database/supabase_provider.dart';
import '../../domain/entity/task_view_type.dart';

class SupabaseQueryBuilder {
  const SupabaseQueryBuilder(this.client);

  final SupabaseClient client;

  PostgrestFilterBuilder<PostgrestList> buildQuery(TaskQuerySpecification spec) {
    final _baseQuery = client.from('tasks').select();

    return _applySpecification(_baseQuery, spec);
  }

  PostgrestTransformBuilder<List<Map<String, dynamic>>> buildPaginationQuery(
    PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
    Cursor? cursor,
    int limit,
  ) {
    if (cursor == null) return query.order('created_at', ascending: false).limit(limit);

    return query.lt('created_at', cursor).order('created_at', ascending: false).limit(limit);
  }

  PostgrestFilterBuilder<PostgrestList> _applySpecification(
    PostgrestFilterBuilder<PostgrestList> query,
    TaskQuerySpecification spec,
  ) {
    return switch (spec) {
      final CompositeSpecification s => s.specifications.fold(
          query,
          _applySpecification,
        ),
      final StatusTaskSpecification s => query //
          .eq('status', s.status.value),
      final OrganizedStatusSpecification o => query.eq(
          'is_organized',
          o.isOrganized,
        ),
      _ => query,
    };
  }
}

final tasksQueryBuilderProvider = Provider<SupabaseQueryBuilder>(
    (ref) => SupabaseQueryBuilder(ref.watch(supabaseClientProvider)));
