import 'package:core_y/core_y.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../filter/domain/entity/filter.dart';
import '../entity/task.dart';
import '../use_case/task_use_case.dart';

abstract class TaskRepository {
  Future<Result<PaginatedResponse<TaskEntity>, AppException>> fetchTasks({
    required Filter filter,
  });

  // AsyncTasksResult fetchTasks(
  //   TaskQuerySpecification spec, {
  //   required Cursor? cursor,
  //   required int limit,
  //   ProjectId? projectId,
  // });

  AsyncTaskResult createTask(TaskPropertiesEntity task);

  AsyncTaskResult getTaskById(TaskId id);

  AsyncTaskResult updateTask(TaskEntity task);

  AsyncTaskResult upsertTask(TaskPropertiesEntity task);
}
