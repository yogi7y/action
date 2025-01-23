import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/strings.dart';
import '../../../../services/connectivity/connetivity_checker.dart';
import '../../domain/entity/project.dart';
import '../../domain/repository/project_repository.dart';
import '../data_source/project_remote_data_source.dart';

class SupabaseProjectRepository with ConnectivityCheckerMixin implements ProjectRepository {
  SupabaseProjectRepository({
    required ConnectivityChecker connectivityChecker,
    required ProjectRemoteDataSource remoteDataSource,
  })  : _connectivityChecker = connectivityChecker,
        _remoteDataSource = remoteDataSource;

  final ConnectivityChecker _connectivityChecker;
  final ProjectRemoteDataSource _remoteDataSource;

  @override
  ConnectivityChecker get connectivityChecker => _connectivityChecker;

  @override
  AsyncProjectsResult fetchProjects() async {
    try {
      final result = checkAndThrowNoInternetException();

      return result.fold(
        onSuccess: (success) async {
          final projects = await _remoteDataSource.fetchProjects();
          return Success(projects);
        },
        onFailure: Failure.new,
      );
    } on SerializationException catch (e) {
      return Failure(e);
    } on PostgrestException catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.message,
          stackTrace: stackTrace,
          userFriendlyMessage: AppStrings.failedToFetchProjects,
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
  AsyncProjectResult getProjectById(ProjectId id) async {
    try {
      final result = checkAndThrowNoInternetException();

      return result.fold(
        onSuccess: (success) async {
          final project = await _remoteDataSource.getProjectById(id);
          return Success(project);
        },
        onFailure: Failure.new,
      );
    } on SerializationException catch (e) {
      return Failure(e);
    } on PostgrestException catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.message,
          stackTrace: stackTrace,
          userFriendlyMessage: AppStrings.failedToFetchProjects,
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
  AsyncProjectResult updateProject(ProjectEntity project) async {
    try {
      final result = checkAndThrowNoInternetException();

      return result.fold(
        onSuccess: (success) async {
          final updatedProject = await _remoteDataSource.updateProject(
            project.toMap(),
            project.id,
          );
          return Success(updatedProject);
        },
        onFailure: Failure.new,
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
