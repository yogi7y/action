import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/database/supabase_provider.dart';
import '../../domain/repository/project_repository.dart';
import '../models/project_model.dart';
import '../models/project_relation_metadata_model.dart';
import 'supabase_remote_data_source.dart';

@immutable
abstract class ProjectRemoteDataSource {
  /// Fetches all available projects from the remote data source
  Future<List<ProjectModel>> fetchProjects();

  /// Fetches all available projects from the remote data source along with their relation metadata
  Future<List<(ProjectModel model, ProjectRelationMetadataModel metadata)>>
      fetchProjectsWithMetadata();

  /// Retrieves a specific project by its unique identifier
  Future<ProjectModel> getProjectById(ProjectId id);

  /// Updates an existing project with the provided data
  ///
  /// [projectData] contains the fields to update
  /// [id] is the unique identifier of the project to update
  Future<ProjectModel> updateProject(Map<String, dynamic> projectData, ProjectId id);

  /// Retrieves metadata about a project's relationships with other entities like tasks and pages.
  Future<ProjectRelationMetadataModel> getProjectRelationMetadata(String projectId);
}

final projectRemoteDataSourceProvider = Provider<ProjectRemoteDataSource>(
  (ref) => SupabaseProjectRemoteDataSource(supabase: ref.watch(supabaseClientProvider)),
);
