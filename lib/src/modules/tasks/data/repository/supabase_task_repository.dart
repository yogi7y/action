import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../filter/domain/entity/filter.dart';
import '../../domain/entity/task.dart';
import '../../domain/repository/task_repository.dart';
import '../../domain/use_case/task_use_case.dart';
import '../data_source/task_remote_data_source.dart';

class SupabaseTaskRepository implements TaskRepository {
  const SupabaseTaskRepository({
    required this.remoteDataSource,
  });

  final TaskRemoteDataSource remoteDataSource;

  @override
  Future<Result<PaginatedResponse<TaskEntity>, AppException>> fetchTasks({
    required Filter filter,
  }) async {
    try {
      final response = await remoteDataSource.fetchTasks(filter: filter);

      return Success(response);
    } catch (e, stackTrace) {
      return Failure(AppException(exception: e, stackTrace: stackTrace));
    }
  }

  @override
  AsyncTaskResult createTask(TaskEntity task) {
    throw UnimplementedError();
  }

  @override
  AsyncTaskResult updateTask(TaskEntity task) {
    throw UnimplementedError();
  }

  @override
  AsyncTaskResult getTaskById(TaskId id) {
    throw UnimplementedError();
  }

  @override
  AsyncTaskResult upsertTask(TaskEntity task) async {
    try {
      final response = await remoteDataSource.upsertTask(task: task);

      return Success(response);
    } catch (e, stackTrace) {
      return Failure(AppException(exception: e, stackTrace: stackTrace));
    }
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final taskRemoteDataSource = ref.watch(taskRemoteDataSourceProvider);

  return SupabaseTaskRepository(remoteDataSource: taskRemoteDataSource);
});
