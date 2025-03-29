import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../../services/database/supabase_provider.dart';
import '../../../filter/domain/entity/filter.dart';
import '../../domain/entity/task_entity.dart';
import 'supabase_task_data_source.dart';

@immutable
abstract class TaskRemoteDataSource {
  /// Fetches tasks from the remote data source.
  ///
  /// [filter] is the filter to apply to the tasks.
  /// For example, if the user wants to fetch tasks for a specific project,
  /// the filter will be the project id.
  /// ```dart
  /// final filter = EqualFilter(field: 'project_id', value: '<project_id_here>');
  /// final tasks = await taskRemoteDataSource.fetchTasks(filter: filter);
  /// ```
  Future<PaginatedResponse<TaskEntity>> fetchTasks({
    required Filter filter,
  });

  /// Creates a task in the remote data source.
  Future<TaskEntity> upsertTask({
    required TaskEntity task,
  });

  /// Fetches unorganised tasks from the remote data source.
  ///
  /// If [fetchInbox] is true, it will fetch inbox tasks (unorganised tasks created in the last 24 hours).
  /// Otherwise, it will fetch all unorganised tasks.
  Future<List<TaskEntity>> fetchUnorganisedTasks({bool fetchInbox = false});
}

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);

  return SupabaseRemoteTaskDataSource(client);
});
