import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/project_repository.dart';

class ProjectUseCase {
  const ProjectUseCase(this.repository);

  final ProjectRepository repository;

  AsyncProjectResult fetchProjects() => repository.fetchProjects();
}

final projectUseCaseProvider = Provider<ProjectUseCase>(
  (ref) => ProjectUseCase(ref.watch(projectRepositoryProvider)),
);
