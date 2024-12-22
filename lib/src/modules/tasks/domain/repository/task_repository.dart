// lib/src/modules/tasks/domain/repository/task_repository.dart

import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/supabase_task_repository.dart';
import '../entity/task.dart';

typedef TaskResult = Result<List<TaskEntity>, AppException>;
typedef AsyncTaskResult = Future<TaskResult>;

abstract class TaskRepository {
  AsyncTaskResult fetchTasks();
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) => SupabaseTaskRepository());
