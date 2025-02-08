import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide SupabaseQueryBuilder;

import '../../../../core/network/paginated_response.dart';
import '../../../projects/domain/repository/project_repository.dart';
import '../../domain/entity/task.dart';
import '../../domain/entity/task_view_type.dart';
import '../../domain/repository/task_repository.dart';
import '../../domain/use_case/task_use_case.dart';
import '../models/task.dart';
import 'query_builder.dart';

class SupabaseTaskRepository implements TaskRepository {
  const SupabaseTaskRepository(this.client, this.queryBuilder);

  final SupabaseClient client;
  final SupabaseQueryBuilder queryBuilder;

  @override
  AsyncTasksResult fetchTasks(
    TaskQuerySpecification spec, {
    required Cursor? cursor,
    required int limit,
    ProjectId? projectId,
  }) async {
    try {
      final query = queryBuilder.buildQuery(spec);

      if (projectId != null) {
        await query.eq('project_id', projectId);
      }

      final paginationQuery = queryBuilder.buildPaginationQuery(
        query,
        cursor,
        limit,
      );

      final response = await paginationQuery.select();

      final tasks = (response as List<dynamic>)
          .map((task) => TaskModel.fromMap(task as Map<String, dynamic>))
          .toList();

      final paginatedResponse = PaginatedResponse<TaskEntity>(results: tasks);

      return Success(paginatedResponse);
    } catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<TaskEntity, AppException>> createTask(TaskPropertiesEntity task) async {
    try {
      final response = await client
          .from('tasks') //
          .insert(task.toMap())
          .select()
          .single();

      final task0 = TaskModel.fromMap(response as Map<String, Object?>? ?? {});

      return Success(task0);
    } catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<TaskEntity, AppException>> updateTask(TaskEntity task) async {
    try {
      final id = task.id;
      final data = task.toMap();

      final response = await client
          .from('tasks') //
          .update(data)
          .eq('id', id)
          .select()
          .single();

      final result = TaskModel.fromMap(response as Map<String, Object?>);
      return Success(result);
    } catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  AsyncTaskResult getTaskById(TaskId id) {
    throw UnimplementedError();
  }

  @override
  AsyncTaskCountResult getTotalTasks(TaskQuerySpecification spec) async {
    try {
      final query = queryBuilder.buildQuery(spec);
      final response = await query.count();

      return Success(response.count);
    } catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
