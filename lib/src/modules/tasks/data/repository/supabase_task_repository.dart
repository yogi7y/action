import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/task.dart';
import '../../domain/repository/task_repository.dart';
import '../models/task.dart';

class SupabaseTaskRepository implements TaskRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<Result<List<TaskEntity>, AppException>> fetchTasks() async {
    try {
      final response = await _supabase.from('tasks').select().order('created_at', ascending: false);

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
}
