import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../../services/database/supabase_provider.dart';
import '../../../projects/domain/repository/project_repository.dart';
import '../../data/repository/query_builder.dart';
import '../../data/repository/supabase_task_repository.dart';
import '../entity/task.dart';
import '../entity/task_view_type.dart';
import '../use_case/task_use_case.dart';

abstract class TaskRepository {
  /// Fetches tasks based on the provided specification
  ///
  /// [spec] The specification for filtering tasks like status, date, etc.
  /// [cursor] Optional cursor for pagination
  /// [limit] Maximum number of tasks to return
  /// [projectId] Optional project ID to filter tasks by
  AsyncTasksResult fetchTasks(
    TaskQuerySpecification spec, {
    required Cursor? cursor,

    /// Limit for pagination
    required int limit,

    /// Filters tasks by project ID
    ProjectId? projectId,
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
