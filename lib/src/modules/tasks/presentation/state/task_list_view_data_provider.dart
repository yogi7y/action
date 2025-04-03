import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/pagination/pagination_strategy.dart';
import '../../../filter/domain/entity/composite/and_filter.dart';
import '../../../filter/domain/entity/variants/select_filter.dart';
import '../../domain/entity/task_status.dart';
import '../models/task_filters.dart';
import '../models/task_list_view_data.dart';

/// In progress = organised tasks + in progress status
final inProgressTaskViewProvider = Provider<TaskListViewData>(
  (ref) => TaskListViewData(
    filter: AndFilter([
      const OrganizedFilter(),
      StatusFilter(TaskStatus.inProgress),
    ]),
    paginationStrategy: const OffsetPaginationStrategy(),
  ),
);

// ignore: flutter_style_todos
/// Todo = organised tasks + todo status
final todoTaskViewProvider = Provider<TaskListViewData>(
  (ref) => TaskListViewData(
    filter: AndFilter([
      const OrganizedFilter(),
      StatusFilter(TaskStatus.todo),
    ]),
    paginationStrategy: const OffsetPaginationStrategy(),
  ),
);

/// Done = organised tasks + done status
final doneTaskViewProvider = Provider<TaskListViewData>(
  (ref) => TaskListViewData(
    filter: AndFilter([
      const OrganizedFilter(),
      StatusFilter(TaskStatus.done),
    ]),
    paginationStrategy: const OffsetPaginationStrategy(),
  ),
);

/// All = All tasks.
final allTaskViewProvider = Provider<TaskListViewData>(
  (ref) => const TaskListViewData(
    filter: SelectFilter(),
    paginationStrategy: OffsetPaginationStrategy(),
  ),
);

/// Unorganised = all unorganised tasks.
final unorganisedTaskViewProvider = Provider<TaskListViewData>(
  (ref) => const TaskListViewData(
    filter: OrganizedFilter(isOrganized: false),
    paginationStrategy: OffsetPaginationStrategy(),
  ),
);

/// A Record of task view name and task view args.
typedef TaskViewArgWithName = ({String name, TaskListViewData args});

/// List of task view to display on the main task screen.
final taskScreenTaskViewsProvider = Provider<List<TaskViewArgWithName>>(
  (ref) => [
    (name: AppStrings.inProgress, args: ref.watch(inProgressTaskViewProvider)),
    (name: AppStrings.todo, args: ref.watch(todoTaskViewProvider)),
    (name: AppStrings.done, args: ref.watch(doneTaskViewProvider)),
    (name: AppStrings.all, args: ref.watch(allTaskViewProvider)),
    (name: AppStrings.unorganised, args: ref.watch(unorganisedTaskViewProvider)),
  ],
);
