import 'package:core_y/src/extensions/time_ago.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/router/routes.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../../../context/presentation/state/context_provider.dart';
import '../../../projects/presentation/state/projects_provider.dart';
import '../../domain/entity/task.dart';
import '../state/task_filter_provider.dart';
import '../state/tasks_provider.dart';

@immutable
class TaskTile extends ConsumerWidget {
  const TaskTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _task = ref.watch(scopedTaskProvider);
    final _spacing = ref.watch(spacingProvider);
    final _fonts = ref.watch(fontsProvider);
    final _colors = ref.watch(appThemeProvider);

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async => context.goNamed(
            AppRoute.taskDetail.name,
            extra: _task,
            pathParameters: {'id': _task.id},
          ),
          child: Container(
            padding: EdgeInsets.only(top: _spacing.xs, bottom: _spacing.sm, right: _spacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCheckbox(
                  padding: EdgeInsets.only(right: _spacing.xs, top: 4, left: _spacing.lg),
                  state: AppCheckboxState.fromTaskStatus(status: _task.status),
                  onChanged: (state) async {
                    final _currentFilter = ref.read(selectedTaskFilterProvider);
                    return ref.read(tasksProvider(_currentFilter).notifier).updateTask(
                          _task.copyWith(status: TaskStatus.fromAppCheckboxState(state)),
                        );
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 60),
                        child: AnimatedTaskName(),
                      ),
                      SizedBox(height: _spacing.xxs),
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
          top: _spacing.xs,
          right: _spacing.lg,
          child: Text(
            _task.createdAt.timeAgo,
            style: _fonts.text.xs.regular.copyWith(
              fontSize: 10,
              height: 16 / 10,
              color: _colors.textTokens.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

@immutable
class AnimatedTaskName extends ConsumerWidget {
  const AnimatedTaskName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _fonts = ref.watch(fontsProvider);
    final _colors = ref.watch(appThemeProvider);
    final _task = ref.watch(scopedTaskProvider);

    return AnimatedDefaultTextStyle(
      duration: defaultAnimationDuration,
      style: _fonts.text.md.regular.copyWith(
        fontSize: 15,
        fontVariations: [
          const FontVariation.weight(450),
        ],
        decoration:
            _task.status == TaskStatus.done ? TextDecoration.lineThrough : TextDecoration.none,
        decorationThickness: 1,
        color: _task.status == TaskStatus.done
            ? _colors.textTokens.secondary
            : _colors.textTokens.primary,
      ),
      child: Text(_task.name),
    );
  }
}

class _TaskMetaDataRow extends ConsumerWidget {
  const _TaskMetaDataRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _task = ref.watch(scopedTaskProvider);

    final _project = ref.watch(projectByIdProvider(_task.projectId ?? ''));
    final _context = ref.watch(contextByIdProvider(_task.contextId ?? ''));
    final _dueDate = _task.dueDate;

    return Wrap(
      spacing: _spacing.xs,
      children: [
        if (_project != null)
          _TaskMetaData(
            iconPath: Assets.hardware,
            value: _project.name,
            onClick: () {},
          ),
        if (_context != null)
          _TaskMetaData(
            iconPath: Assets.tag,
            value: _context.name,
            onClick: () {},
          ),
        if (_dueDate != null)
          _TaskMetaData(
            iconPath: Assets.calendarMonth,
            value: _dueDate.relativeDate,
            onClick: () {},
          ),
      ],
    );
  }
}

class _TaskMetaData extends ConsumerWidget {
  const _TaskMetaData({
    required this.iconPath,
    required this.value,
    this.onClick,
  });

  final String iconPath;
  final String value;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 14,
            width: 14,
            colorFilter: ColorFilter.mode(
              _colors.textTokens.secondary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            value,
            style: _fonts.text.xs.medium.copyWith(
              color: _colors.textTokens.secondary,
            ),
          )
        ],
      ),
    );
  }
}
