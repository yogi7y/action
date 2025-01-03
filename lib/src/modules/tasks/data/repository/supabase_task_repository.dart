import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/paginated_response.dart';
import '../../domain/entity/task.dart';
import '../../domain/entity/task_view_type.dart';
import '../../domain/repository/task_repository.dart';
import '../../domain/use_case/task_use_case.dart';
import '../models/task.dart';
import 'query_builder.dart';

class SupabaseTaskRepository implements TaskRepository {
  const SupabaseTaskRepository(this.client, this.queryBuilder);

  final SupabaseClient client;
  final TasksQueryBuilder<PostgrestFilterBuilder<PostgrestList>> queryBuilder;

  @override
  AsyncTasksResult fetchTasks(
    TaskQuerySpecification spec, {
    required int page,
    required int pageSize,
  }) async {
    try {
      final _query = queryBuilder.buildQuery(spec);

      final _start = pageSize * (page - 1);
      final _end = (pageSize * page) - 1;

      final _totalCount = await _query.count();

      final _queryWithPagination = _query
          .limit(pageSize) //
          .range(_start, _end)
          .order('created_at', ascending: false);

      final _response = await _queryWithPagination.select();

      final tasks = (_response as List<dynamic>)
          .map((task) => TaskModel.fromMap(task as Map<String, dynamic>))
          .toList();

      final _paginatedResponse = PaginatedResponse<TaskEntity>(
        results: tasks,
        totalPages: _totalCount.count,
        currentPage: page,
      );

      return Success(_paginatedResponse);
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
      final _response = await client
          .from('tasks') //
          .insert(task.toMap())
          .select()
          .single();

      final _task = TaskModel.fromMap(_response as Map<String, Object?>? ?? {});

      return Success(_task);
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
      final _id = task.id;
      final _data = task.toMap();

      final _response = await client
          .from('tasks') //
          .update(_data)
          .eq('id', _id)
          .select()
          .single();

      final _result = TaskModel.fromMap(_response as Map<String, Object?>);
      return Success(_result);
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
      final _query = queryBuilder.buildQuery(spec);
      final _response = await _query.count();

      return Success(_response.count);
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
