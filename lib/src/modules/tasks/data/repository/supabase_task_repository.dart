import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/task.dart';
import '../../domain/entity/task_view_type.dart';
import '../../domain/repository/task_repository.dart';
import '../models/task.dart';
import 'query_builder.dart';

class SupabaseTaskRepository implements TaskRepository {
  const SupabaseTaskRepository(this.client, this.queryBuilder);

  final SupabaseClient client;
  final TasksQueryBuilder<PostgrestFilterBuilder<PostgrestList>> queryBuilder;

  @override
  Future<Result<List<TaskEntity>, AppException>> fetchTasks(TaskQuerySpecification spec) async {
    try {
      final _query = queryBuilder.buildQuery(spec);

      final _response = await _query.select();

      final tasks = (_response as List<dynamic>)
          .map((task) => TaskModel.fromMap(task as Map<String, dynamic>))
          .toList();

      return Success(tasks);
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
}
