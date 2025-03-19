import 'dart:async';

import 'package:core_y/src/extensions/time_ago.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/mixin/keyboard_mixin.dart';
import '../../../../core/router/routes.dart';
import '../../../../design_system/design_system.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/buttons/clickable_svg.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../../../context/presentation/state/context_provider.dart';
import '../../../projects/presentation/state/projects_provider.dart';
import '../../domain/entity/task_status.dart';
import '../state/scoped_task_provider.dart';
import '../state/task_view_provider.dart';
import '../state/tasks_provider.dart';

@immutable
class TaskTile extends ConsumerWidget with KeyboardMixin {
  const TaskTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexedTask = ref.watch(scopedTaskProvider);
    final task = indexedTask.task;
    final index = indexedTask.index;

    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);
    final colors = ref.watch(appThemeProvider);

    final topPadding = spacing.xs;
    final bottomPadding = spacing.sm;
    final selectedTaskView = ref.watch(selectedTaskViewProvider);
    final tasks = ref.watch(tasksNotifierProvider(selectedTaskView)).valueOrNull ?? [];

    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async => context.goNamed(
                AppRoute.taskDetail.name,
                extra: (value: (data: task, id: null), index: index),
                pathParameters: {'id': task.id ?? ''},
              ),
              child: Container(
                padding: EdgeInsets.only(
                  right: spacing.lg,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCheckbox(
                      padding: EdgeInsets.only(
                        right: spacing.xs,
                        top: 4 + topPadding,
                        left: spacing.lg,
                        bottom: bottomPadding,
                      ),
                      state: AppCheckboxState.fromTaskStatus(status: task.status),
                      onChanged: (state) async {
                        final taskView = ref.read(scopedTaskViewProvider);
                        unawaited(
                          ref
                              .read(tasksNotifierProvider(taskView).notifier)
                              .toggleCheckbox(index, TaskStatus.fromAppCheckboxState(state)),
                        );
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 60, top: topPadding),
                            child: const AnimatedTaskName(),
                          ),
                          SizedBox(height: spacing.xxs),
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: _TaskMetaDataRow(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: spacing.xs,
              right: spacing.lg,
              child: Text(
                task.createdAt?.timeAgo ?? '',
                style: fonts.text.xs.regular.copyWith(
                  fontSize: 10,
                  height: 16 / 10,
                  color: colors.textTokens.secondary,
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: index == tasks.length - 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
                child: Text(
              'All caught up!',
              style: fonts.text.xs.regular.copyWith(
                color: colors.textTokens.secondary,
              ),
            )),
          ),
        )
      ],
    );
  }
}

@immutable
class AnimatedTaskName extends ConsumerWidget {
  const AnimatedTaskName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fonts = ref.watch(fontsProvider);
    final colors = ref.watch(appThemeProvider);
    final task = ref.watch(scopedTaskProvider).task;

    return AnimatedDefaultTextStyle(
      duration: defaultAnimationDuration,
      style: fonts.text.md.regular.copyWith(
        fontSize: 15,
        fontVariations: [
          const FontVariation.weight(450),
        ],
        decoration:
            task.status == TaskStatus.done ? TextDecoration.lineThrough : TextDecoration.none,
        decorationThickness: 1,
        color: task.status == TaskStatus.done
            ? colors.textTokens.secondary
            : colors.textTokens.primary,
      ),
      child: Text(task.name),
    );
  }
}

class _TaskMetaDataRow extends ConsumerWidget {
  const _TaskMetaDataRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    final task = ref.watch(scopedTaskProvider).task;

    final project = ref.watch(projectByIdProvider(task.projectId ?? ''))?.project;
    final context0 = ref.watch(contextByIdProvider(task.contextId ?? ''));
    final dueDate = task.dueDate;

    return Wrap(
      spacing: spacing.xs,
      children: [
        if (project != null)
          _TaskMetaData(
            icon: AppIcons.hammerOutlined,
            value: project.name,
            onClick: () {},
          ),
        if (context0 != null)
          _TaskMetaData(
            icon: AppIcons.tagOutlined,
            value: context0.name,
            onClick: () {},
          ),
        if (dueDate != null)
          _TaskMetaData(
            icon: AppIcons.calendarOutlined,
            value: dueDate.relativeDate,
            onClick: () {},
          ),
      ],
    );
  }
}

@immutable
class _TaskMetaData extends ConsumerWidget {
  const _TaskMetaData({
    required this.icon,
    required this.value,
    this.onClick,
  });

  final IconData icon;
  final String value;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconButton(
            icon: icon,
            size: 14,
            color: colors.textTokens.secondary,
          ),
          const SizedBox(width: 2),
          Text(
            value,
            style: fonts.text.xs.medium.copyWith(
              color: colors.textTokens.secondary,
            ),
          )
        ],
      ),
    );
  }
}
