import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/database/supabase_provider.dart';
import '../../data/repository/supabase_task_repository.dart';
import '../entity/task.dart';
import '../use_case/task_use_case.dart';

abstract class TaskRepository {
  AsyncTaskResult fetchTasks();

  Future<Result<TaskEntity, AppException>> createTask(TaskPropertiesEntity task);
}

final taskRepositoryProvider =
    Provider<TaskRepository>((ref) => SupabaseTaskRepository(ref.watch(supabaseClientProvider)));
