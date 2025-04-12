// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../design_system/design_system.dart';
// import '../models/task_view.dart';
// import '../sections/task_input_field.dart';
// import '../sections/tasks_filters.dart';
// import '../state/filter_keys_provider.dart';
// import '../state/new_task_provider.dart';
// import '../state/task_view_provider.old.dart';
// import '../widgets/add_remove_floating_action_button.dart';

// class TaskModule extends ConsumerStatefulWidget {
//   const TaskModule({
//     super.key,
//   });

//   @override
//   ConsumerState<TaskModule> createState() => _TaskModuleState();
// }

// class _TaskModuleState extends ConsumerState<TaskModule> {
//   late final pageController = ref.watch(tasksPageControllerProvider);

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _TaskModuleData(key: widget.key);
//   }
// }

// class _TaskModuleData extends ConsumerStatefulWidget {
//   const _TaskModuleData({super.key});

//   @override
//   ConsumerState<_TaskModuleData> createState() => _TaskModuleDataState();
// }

// class _TaskModuleDataState extends ConsumerState<_TaskModuleData> {
//   late final _pageController = ref.watch(tasksPageControllerProvider);

//   @override
//   void initState() {
//     super.initState();

//     final filters = ref.read(taskViewProvider);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(filterKeysProvider.notifier).initializeKeys(filters);
//       _handleLoadedTaskView();
//       _pageController.addListener(_onPageChanged);
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void _handleLoadedTaskView() {
//     ref.read(loadedTaskViewsProvider);
//     final selectedTaskView = ref.read(selectedTaskViewProvider);

//     ref.read(loadedTaskViewsProvider.notifier).update(
//       (state) {
//         if (state.contains(selectedTaskView)) return state;

//         return {...state, selectedTaskView};
//       },
//     );
//   }

//   void _onPageChanged() {
//     final controller = ref.read(tasksPageControllerProvider);
//     final page = controller.page?.round() ?? 0;
//     final filters = ref.read(taskViewProvider);

//     if (page >= 0 && page < filters.length) {
//       _scrollToSelectedFilter(filters[page]);
//     }
//   }

//   void _scrollToSelectedFilter(TaskView selectedFilter) {
//     final filterKey = ref.read(filterKeysProvider.notifier).getKey(selectedFilter);
//     if (filterKey?.currentContext == null) return;

//     unawaited(
//       Scrollable.ensureVisible(
//         filterKey!.currentContext!,
//         alignment: 0.7,
//         duration: const Duration(milliseconds: 100),
//         curve: Curves.linear,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final spacing = ref.watch(spacingProvider);
//     final filters = ref.watch(taskViewProvider);
//     final taskModuleData = ref.watch(taskModelDataProvider);
//     ref.watch(filterKeysProvider); // watching for any rebuilds.

//     final floatingActionButton = AddRemoveFloatingActionButton(
//       onStateChanged: (state) =>
//           ref.read(isTaskTextInputFieldVisibleProvider.notifier).update((value) => !value),
//     );

//     final taskFilters = TasksFiltersOld(
//       filterViews: ref.read(filterKeysProvider.notifier).getFilterViews(),
//       smallerChips: taskModuleData.smallerChips,
//     );

//     if (taskModuleData.isSliver)
//       return Scaffold(
//         body: NestedScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           headerSliverBuilder: (context, _) {
//             return [
//               SliverToBoxAdapter(child: taskFilters),
//               SliverToBoxAdapter(child: SizedBox(height: spacing.sm)),
//               const SliverToBoxAdapter(child: TaskInputFieldVisibility()),
//               SliverToBoxAdapter(child: SizedBox(height: spacing.xs)),
//             ];
//           },
//           body: PageView(
//             controller: _pageController,
//             children: filters.map((filter) => TasksListViewOld(taskView: filter)).toList(),
//             onPageChanged: (value) =>
//                 ref.read(selectedTaskViewProvider.notifier).selectByIndex(value),
//           ),
//         ),
//         floatingActionButton: floatingActionButton,
//       );

//     return Scaffold(
//       body: Column(
//         children: [
//           if (taskModuleData.showFilters) ...[
//             taskFilters,
//             SizedBox(height: spacing.sm),
//           ],
//           const TaskInputFieldVisibility(),
//           SizedBox(height: spacing.xs),
//           Expanded(
//             child: PageView(
//               controller: _pageController,
//               children: filters.map((filter) => TasksListViewOld(taskView: filter)).toList(),
//               onPageChanged: (value) =>
//                   ref.read(selectedTaskViewProvider.notifier).selectByIndex(value),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: floatingActionButton,
//     );
//   }
// }

// final taskModelDataProvider = Provider<TaskModuleData>(
//   (ref) => throw UnimplementedError('Ensure to override taskModuleDataProvider'),
//   name: 'taskModuleDataProvider',
// );

// @immutable
// class TaskModuleData {
//   const TaskModuleData({
//     required this.taskViews,
//     this.isSliver = false,
//     this.smallerChips = false,
//     this.showFilters = true,
//     this.onRefresh,
//   });

//   final List<TaskView> taskViews;
//   final bool isSliver;
//   final bool smallerChips;
//   final bool showFilters;
//   final Future<void> Function()? onRefresh;

//   @override
//   String toString() =>
//       'TaskModuleData(taskViews: $taskViews, isSliver: $isSliver, smallerChips: $smallerChips)';

//   @override
//   bool operator ==(covariant TaskModuleData other) {
//     if (identical(this, other)) return true;

//     return listEquals(other.taskViews, taskViews) &&
//         other.isSliver == isSliver &&
//         other.smallerChips == smallerChips &&
//         other.showFilters == showFilters &&
//         other.onRefresh == onRefresh;
//   }

//   @override
//   int get hashCode => Object.hash(
//         taskViews,
//         isSliver,
//         smallerChips,
//         showFilters,
//         onRefresh,
//       );
// }
