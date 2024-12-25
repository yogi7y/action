import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/task.dart';
import '../../domain/repository/task_repository.dart';
import '../models/task.dart';

class SupabaseTaskRepository implements TaskRepository {
  const SupabaseTaskRepository(this.client);

  final SupabaseClient client;

  @override
  Future<Result<List<TaskEntity>, AppException>> fetchTasks() async {
    try {
      final response = await client.from('tasks').select().order('created_at', ascending: false);

      final tasks = (response as List<dynamic>)
          .map((task) => TaskModel.fromMap(task as Map<String, dynamic>))
          .toList();

      return Success(tasks);
    } on PostgrestException catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.message,
          stackTrace: stackTrace,
        ),
      );
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
}
