import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/logger/logger.dart';
import '../../../../services/connectivity/connectivity_checker.dart';
import '../../domain/entity/project.dart';
import '../../domain/repository/project_repository.dart';
import '../../presentation/view_models/project_view_model.dart';
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

  @override
  AsyncProjectRelationMetadataResult getProjectRelationMetadata(String projectId) async {
    try {
      final result = checkAndThrowNoInternetException();

      return result.fold(
        onSuccess: (success) async {
          final metadata = await _remoteDataSource.getProjectRelationMetadata(projectId);
          return Success(metadata);
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

  @override
  AsyncProjectsWithMetadataResult fetchProjectsWithMetadata() async {
    try {
      final result = checkAndThrowNoInternetException();

      return result.asyncFold(
        onSuccess: (success) async {
          final projectResult = await _remoteDataSource.fetchProjectsWithMetadata();

          final projectViewModels = projectResult
              .map((project) => ProjectViewModel(project: project.$1, metadata: project.$2))
              .toList();

          return Success(projectViewModels);
        },
        onFailure: (failure) {
          logger('fetchProjectsWithMetadata repository failure: $failure');
          return Failure(failure);
        },
      );
    } catch (e, stackTrace) {
      logger('fetchProjectsWithMetadata repository error: $e');
      return Failure(
        AppException(
          exception: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
