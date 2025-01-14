import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/project.dart';
import '../repository/project_repository.dart';

class ProjectUseCase {
  const ProjectUseCase(this.repository);

  final ProjectRepository repository;

  AsyncProjectsResult fetchProjects() => repository.fetchProjects();

  AsyncProjectResult getProjectById(ProjectId id) => repository.getProjectById(id);

  AsyncProjectResult updateProject(ProjectEntity project) => repository.updateProject(project);
}

final projectUseCaseProvider = Provider<ProjectUseCase>(
  (ref) => ProjectUseCase(ref.watch(projectRepositoryProvider)),
);
