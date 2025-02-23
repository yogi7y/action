import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/database.dart';
import '../../../../core/extensions/list_extension.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../filter/data/models/supabase_filter_operations.dart';
import '../../../filter/domain/entity/filter.dart';
import '../../domain/entity/task.dart';
import '../models/task.dart';
import 'task_remote_data_source.dart';

class SupabaseRemoteTaskDataSource implements TaskRemoteDataSource {
  const SupabaseRemoteTaskDataSource(this.client);

  final SupabaseClient client;

  @override
  Future<PaginatedResponse<TaskEntity>> fetchTasks({required Filter filter}) async {
    final query = client.from('tasks').select();
    final filterOperations = SupabaseFilterOperations(query);

    final allFilterAppliedQuery = filter.accept(filterOperations);

    final response = await allFilterAppliedQuery.count();

    final total = response.count;
    final tasks = response.data;

    final tasksModel = tasks.tryMap(TaskModel.fromMap).toList();

    final paginatedResponse = PaginatedResponse<TaskEntity>(
      results: tasksModel,
      total: total,
    );

    return paginatedResponse;
  }

  @override
  Future<TaskEntity> upsertTask({
    required TaskEntity task,
  }) async {
    final response = await client.from(DatabaseConstants.tasksTable).upsert(task.toMap()).select();

    final first = response.first as Map<String, Object?>?;

    if (first == null) {
      throw AppException(
        exception: 'Got empty response from the server. $response',
        stackTrace: StackTrace.current,
      );
    }

    return TaskModel.fromMap(first);
  }
}
