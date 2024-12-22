import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/project.dart';
import '../../domain/use_case/project_use_case.dart';

final projectsProvider = FutureProvider<List<ProjectEntity>>((ref) async {
  final useCase = ref.watch(projectUseCaseProvider);
  final result = await useCase.fetchProjects();

  return result.fold(
    onSuccess: (projects) => projects,
    onFailure: (error) => throw error,
  );
});

final projectByIdProvider = Provider.family<ProjectEntity?, String>((ref, projectId) {
  final projectsAsync = ref.watch(projectsProvider);

  return projectsAsync.whenOrNull(
    data: (projects) => projects.firstWhereOrNull(
      (project) => project.id == projectId,
    ),
  );
});
