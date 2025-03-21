import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/router/routes.dart';
import '../../../tasks/domain/entity/task_status.dart';
import '../../../tasks/presentation/models/task_view.dart';
import '../../../tasks/presentation/models/task_view_variants.dart';

final projectTaskViewProvider = Provider.family<List<TaskView>, String>(
  (ref, projectId) => [
    ProjectTaskView(
      projectId: projectId,
      status: TaskStatus.inProgress,
      ui: const TaskViewUI(label: AppStrings.inProgress),
      id: TaskView.generateId(
        screenName: AppRoute.projectDetail.name,
        viewName: AppStrings.inProgress.toLowerCase().replaceAll(' ', '_'),
      ),
    ),
    ProjectTaskView(
      projectId: projectId,
      status: TaskStatus.todo,
      ui: const TaskViewUI(label: AppStrings.todo),
      id: TaskView.generateId(
        screenName: AppRoute.projectDetail.name,
        viewName: AppStrings.todo.toLowerCase().replaceAll(' ', '_'),
      ),
    ),
    ProjectTaskView(
      projectId: projectId,
      status: TaskStatus.done,
      ui: const TaskViewUI(label: AppStrings.done),
      id: TaskView.generateId(
        screenName: AppRoute.projectDetail.name,
        viewName: AppStrings.done.toLowerCase().replaceAll(' ', '_'),
      ),
    ),
    ProjectTaskView(
      projectId: projectId,
      ui: const TaskViewUI(label: AppStrings.all),
      id: TaskView.generateId(
        screenName: AppRoute.projectDetail.name,
        viewName: AppStrings.all.toLowerCase().replaceAll(' ', '_'),
      ),
    ),
  ],
);

// final selectedProjectTaskViewProvider =
//     NotifierProvider.family<SelectedProjectTaskView, TaskView, String>(
//   SelectedProjectTaskView.new,
// );

// class SelectedProjectTaskView extends FamilyNotifier<TaskView, String> {
//   @override
//   TaskView build(String arg) => ref.read(projectTaskViewProvider(arg)).first;

//   void selectByIndex(int index) {
//     final filters = ref.read(projectTaskViewProvider(arg));
//     if (index >= 0 && index < filters.length) {
//       final newState = filters[index];
//       if (state != newState) state = newState;
//     }
//   }
// }

// /// A list of in-memory loaded project task views.
// /// What this means is that these task views were accessed and loaded in-memory for this app session.
// final loadedProjectTaskViewsProvider =
//     StateProvider.family<Set<TaskView>, String>((ref, projectId) {
//   /// Update the controller state when the selected task view changes.
//   /// Keep on adding the new selected task view to the controller state.
//   ref.listen(
//     selectedProjectTaskViewProvider(projectId),
//     (previous, next) => ref.controller.update((state) {
//       if (state.contains(next)) return state;
//       return {...state, next};
//     }),
//   );

//   return {};
// });
