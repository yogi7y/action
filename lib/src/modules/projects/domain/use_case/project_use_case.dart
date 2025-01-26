import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/paginated_response.dart';
import '../../../tasks/domain/use_case/task_use_case.dart';
import '../entity/project.dart';
import '../repository/project_repository.dart';

class ProjectUseCase {
  const ProjectUseCase(this.repository);

  final ProjectRepository repository;

  AsyncProjectsResult fetchProjects() => repository.fetchProjects();

  AsyncProjectResult getProjectById(ProjectId id) => repository.getProjectById(id);

  AsyncProjectResult updateProject(ProjectEntity project) => repository.updateProject(project);

  AsyncProjectRelationMetadataResult getProjectRelationMetadata(String projectId) =>
      repository.getProjectRelationMetadata(projectId);

  AsyncProjectsWithMetadataResult fetchProjectsWithMetadata() =>
      repository.fetchProjectsWithMetadata();

  /// Fetches all tasks associated with a specific project
  ///
  /// [projectId] The ID of the project to fetch tasks for
  /// [cursor] Optional cursor for pagination
  /// [limit] Maximum number of tasks to return
  AsyncTasksResult getProjectTasks(
    ProjectId projectId, {
    required int limit,
    Cursor? cursor,
  }) =>
      repository.getProjectTasks(
        projectId,
        cursor: cursor,
        limit: limit,
      );
}

final projectUseCaseProvider = Provider<ProjectUseCase>(
  (ref) => ProjectUseCase(ref.watch(projectRepositoryProvider)),
);
