import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/assets.dart';
import '../../../../design_system/spacing/spacing.dart';
import '../../../../design_system/typography/typography.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../../../dashboard/presentation/state/app_theme.dart';
import '../../domain/entity/task.dart';
import '../state/tasks_provider.dart';

@immutable
class TaskTile extends ConsumerWidget {
  const TaskTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _task = ref.watch(scopedTaskProvider);
    final _colors = ref.watch(appThemeProvider);
    final _spacing = ref.watch(spacingProvider);
    final _fonts = ref.watch(fontsProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: _spacing.lg) +
          EdgeInsets.only(top: _spacing.xs, bottom: _spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCheckbox(
            state: AppCheckboxState.fromTaskStatus(status: _task.status),
          ),
          SizedBox(width: _spacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: Text(
                    _task.name,
                    style: _fonts.text.sm.medium,
                  ),
                ),
                SizedBox(height: _spacing.xxs),
                Row(
                  spacing: _spacing.xs,
                  children: [
                    _TaskMetaData(
                      iconPath: Assets.hardware,
                      value: 'Project Name',
                      onClick: () {},
                    ),
                    _TaskMetaData(
                      iconPath: Assets.tag,
                      value: 'Context Name',
                      onClick: () {},
                    ),
                    _TaskMetaData(
                      iconPath: Assets.calendarMonth,
                      value: 'Tomorrow, 9:00 AM',
                      onClick: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
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
    final _spacing = ref.watch(spacingProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: Row(
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
          SizedBox(width: _spacing.xxs),
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
