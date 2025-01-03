import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../design_system/design_system.dart';
import '../../design_system/themes/base/semantics/status_tokens.dart';
import '../../modules/tasks/domain/entity/task.dart';

enum StatusType {
  todo('Todo', Assets.circle),
  inProgress('In Progress', Assets.circleWithDots),
  done('Done', Assets.circleWithCheck);

  const StatusType(this.label, this.icon);

  final String label;
  final String icon;

  static StatusType fromTaskStatus(TaskStatus taskStatus) {
    switch (taskStatus) {
      case TaskStatus.todo:
        return StatusType.todo;
      case TaskStatus.inProgress:
        return StatusType.inProgress;
      case TaskStatus.done:
        return StatusType.done;
    }
  }
}

@immutable
class StatusWidget extends ConsumerWidget {
  const StatusWidget({
    required this.status,
    this.showIcon = true,
    super.key,
  });

  final StatusType status;
  final bool showIcon;

  StatusTokens _getStatusTokens(AppTheme theme) {
    switch (status) {
      case StatusType.todo:
        return theme.statusTodo;
      case StatusType.inProgress:
        return theme.statusInProgress;
      case StatusType.done:
        return theme.statusDone;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _spacing = ref.watch(spacingProvider);

    final _statusTokens = _getStatusTokens(_colors);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing.sm,
        vertical: _spacing.xxs,
      ),
      decoration: ShapeDecoration(
        color: _statusTokens.background,
        shape: StadiumBorder(
          side: BorderSide(
            color: _statusTokens.border,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon) ...[
            SvgPicture.asset(
              status.icon,
              height: 16,
              width: 16,
              colorFilter: ColorFilter.mode(
                _statusTokens.text,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            status.label,
            style: _fonts.text.sm.medium.copyWith(
              color: _statusTokens.text,
            ),
          ),
        ],
      ),
    );
  }
}
