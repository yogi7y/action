import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/connectivity/connetivity_checker.dart';
import '../../../../services/database/supabase_provider.dart';
import '../../data/data_source/project_remote_data_source.dart';
import '../../data/data_source/supabase_remote_data_source.dart';
import '../../data/repository/supabase_project_repository.dart';
import '../../presentation/view_models/project_view_model.dart';
import '../entity/project.dart';
import '../entity/project_relation_metadata.dart';

typedef ProjectId = String;
typedef ProjectResult = Result<ProjectEntity, AppException>;
typedef AsyncProjectResult = Future<ProjectResult>;

typedef ProjectsResult = Result<List<ProjectEntity>, AppException>;
typedef AsyncProjectsResult = Future<ProjectsResult>;

typedef ProjectRelationMetadataResult = Result<ProjectRelationMetadata, AppException>;
typedef AsyncProjectRelationMetadataResult = Future<ProjectRelationMetadataResult>;

typedef ProjectsWithMetadataResult = Result<List<ProjectViewModel>, AppException>;
typedef AsyncProjectsWithMetadataResult = Future<ProjectsWithMetadataResult>;

abstract class ProjectRepository {
  /// Fetches all available projects
  AsyncProjectsResult fetchProjects();

  /// Retrieves a specific project by its ID
  AsyncProjectResult getProjectById(ProjectId id);

  /// Updates an existing project
  AsyncProjectResult updateProject(ProjectEntity project);

  /// Retrieves metadata about a project's relationships with other entities like tasks and pages.
  AsyncProjectRelationMetadataResult getProjectRelationMetadata(String projectId);

  /// Fetches all the projects with their metadata
  AsyncProjectsWithMetadataResult fetchProjectsWithMetadata();
}

final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => SupabaseProjectRepository(
    connectivityChecker: ref.watch(connectivityCheckerProvider),
    remoteDataSource: ref.watch(projectRemoteDataSourceProvider),
  ),
);

// Add provider for remote data source
final projectRemoteDataSourceProvider = Provider<ProjectRemoteDataSource>(
  (ref) => SupabaseProjectRemoteDataSource(supabase: ref.watch(supabaseClientProvider)),
);
