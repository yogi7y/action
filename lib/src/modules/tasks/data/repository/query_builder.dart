import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../services/database/supabase_provider.dart';
import '../../domain/entity/task_view_type.dart';

abstract class TasksQueryBuilder<T> {
  T buildQuery(TaskQuerySpecification spec);
}

class SupabaseQueryBuilder implements TasksQueryBuilder<PostgrestFilterBuilder<PostgrestList>> {
  const SupabaseQueryBuilder(this.client);

  final SupabaseClient client;

  @override
  PostgrestFilterBuilder<PostgrestList> buildQuery(TaskQuerySpecification spec) {
    final _baseQuery = client.from('tasks').select();

    return _applySpecification(_baseQuery, spec);
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
      final StatusTaskSpecification s => query.eq('status', s.status.value),
      final OrganizedTaskSpecification o =>
        query.eq('is_organized', o.isOrganized).eq('is_in_inbox', o.isInInbox),
      _ => query,
    };
  }
}

final tasksQueryBuilderProvider =
    Provider<TasksQueryBuilder<PostgrestFilterBuilder<PostgrestList>>>(
        (ref) => SupabaseQueryBuilder(ref.watch(supabaseClientProvider)));
