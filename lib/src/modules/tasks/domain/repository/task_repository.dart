import 'package:core_y/core_y.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../filter/domain/entity/filter.dart';
import '../entity/task_entity.dart';
import '../use_case/task_use_case.dart';

abstract class TaskRepository {
  Future<Result<PaginatedResponse<TaskEntity>, AppException>> fetchTasks({
    required Filter filter,
  });

  AsyncTaskResult getTaskById(TaskId id);

  AsyncTaskResult upsertTask(TaskEntity task);

  /// Fetches unorganised tasks.
  /// If [fetchInbox] is true, it will fetch inbox tasks (unorganised tasks created in the last 24 hours).
  /// Otherwise, it will fetch all unorganised tasks.
  Future<Result<List<TaskEntity>, AppException>> fetchUnorganisedTasks({bool fetchInbox = false});
}
