import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/supabase_project_repository.dart';
import '../entity/project.dart';

typedef ProjectId = String;
typedef ProjectResult = Result<ProjectEntity, AppException>;
typedef AsyncProjectResult = Future<ProjectResult>;

typedef ProjectsResult = Result<List<ProjectEntity>, AppException>;
typedef AsyncProjectsResult = Future<ProjectsResult>;

abstract class ProjectRepository {
  AsyncProjectsResult fetchProjects();
  // Add this new method
  AsyncProjectResult getProjectById(ProjectId id); // Add this

  AsyncProjectResult updateProject(ProjectEntity project);
}

final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => SupabaseProjectRepository(),
);
