import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/project.dart';
import '../../domain/use_case/project_use_case.dart';
import '../view_models/project_view_model.dart';

typedef ProjectOrId = ({String? id, ProjectEntity? value});
typedef UpdateProjectCallback = ProjectEntity Function(ProjectEntity project);

final projectDetailProvider =
    FutureProvider.autoDispose.family<ProjectEntity, ProjectOrId>((ref, dataOrId) async {
  // If we have data, return it directly
  if (dataOrId.value != null) return dataOrId.value!;

  // Otherwise fetch using ID
  if (dataOrId.id != null) {
    final useCase = ref.watch(projectUseCaseProvider);
    final result = await useCase.getProjectById(dataOrId.id!);

    return result.fold(
      onSuccess: (project) => project,
      onFailure: (error) => throw error,
    );
  }

  throw Exception('Either id or value must be provided');
});

final projectNotifierProvider = NotifierProvider.autoDispose<ProjectNotifier, ProjectViewModel>(
  () => throw UnimplementedError('Ensure to override projectNotifierProvider'),
);

class ProjectNotifier extends AutoDisposeNotifier<ProjectViewModel> {
  ProjectNotifier(this.projectViewModel);

  final ProjectViewModel projectViewModel;

  late final _useCase = ref.read(projectUseCaseProvider);

  @override
  ProjectViewModel build() => projectViewModel;

  Future<void> updateProject(UpdateProjectCallback update) async {
    final previousState = state;
    final updatedProject = update(state.project);

    // Optimistic update
    state = state.copyWith(project: updatedProject);

    try {
      final result = await _useCase.updateProject(updatedProject);

      await result.fold(
        onSuccess: (project) async {
          state = state.copyWith(project: project);
        },
        onFailure: (error) async {
          state = previousState;
          throw error;
        },
      );
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  void updateTaskCount(int Function(int current) update) =>
      state = state.copyWith(totalTasks: update(state.totalTasks));

  void updatePageCount(int Function(int current) update) =>
      state = state.copyWith(totalPages: update(state.totalPages));
}
