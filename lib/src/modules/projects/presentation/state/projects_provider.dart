import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/project_use_case.dart';
import '../view_models/project_view_model.dart';

final projectsProvider =
    AsyncNotifierProvider<ProjectsNotifier, List<ProjectViewModel>>(ProjectsNotifier.new);

class ProjectsNotifier extends AsyncNotifier<List<ProjectViewModel>> {
  @override
  Future<List<ProjectViewModel>> build() async {
    final useCase = ref.watch(projectUseCaseProvider);
    final result = await useCase.fetchProjectsWithMetadata();

    return result.fold(
      onSuccess: (projects) => projects,
      onFailure: (error) => throw error,
    );
  }
}

final projectByIdProvider = Provider.family<ProjectViewModel?, String>((ref, projectId) {
  final projectsAsync = ref.watch(projectsProvider);

  return projectsAsync.whenOrNull(
    data: (projects) => projects.firstWhereOrNull(
      (project) => project.project.id == projectId,
    ),
  );
});

/// Overriding in the list view while rendering the project card.
final scopedProjectProvider = Provider<ProjectViewModel>(
    (ref) => throw UnimplementedError('Ensure to override scopedProjectProvider'));
