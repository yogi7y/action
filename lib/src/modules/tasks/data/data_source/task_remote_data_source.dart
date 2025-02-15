import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../../services/database/supabase_provider.dart';
import '../../../filter/domain/entity/filter.dart';
import '../../domain/entity/task.dart';
import '../models/task.dart';
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
  Future<PaginatedResponse<TaskModel>> fetchTasks({
    required Filter filter,
  });

  /// Creates a task in the remote data source.
  Future<TaskEntity> upsertTask({
    required TaskPropertiesEntity task,
  });
}

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);

  return SupabaseRemoteTaskDataSource(client);
});
