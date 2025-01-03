import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/database/supabase_provider.dart';
import '../../data/repository/query_builder.dart';
import '../../data/repository/supabase_task_repository.dart';
import '../entity/task.dart';
import '../entity/task_view_type.dart';
import '../use_case/task_use_case.dart';

abstract class TaskRepository {
  AsyncTasksResult fetchTasks(
    TaskQuerySpecification spec, {
    required int page,
    required int pageSize,
  });

  AsyncTaskCountResult getTotalTasks(TaskQuerySpecification spec);

  AsyncTaskResult createTask(TaskPropertiesEntity task);

  AsyncTaskResult getTaskById(TaskId id);

  AsyncTaskResult updateTask(TaskEntity task);
}

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => SupabaseTaskRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(tasksQueryBuilderProvider),
  ),
);
