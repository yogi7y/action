import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../design_system/design_system.dart';
import '../../design_system/themes/base/semantics/status_tokens.dart';
import '../../modules/tasks/domain/entity/task.dart';
import '../checkbox/checkbox.dart';

extension on AppCheckboxState {
  String get iconPath => switch (this) {
        AppCheckboxState.checked => AssetsV2.circleCheck,
        AppCheckboxState.intermediate => AssetsV2.circleDashed,
        AppCheckboxState.unchecked => AssetsV2.circle,
      };
}

@immutable
class StatusWidget extends ConsumerWidget {
  const StatusWidget({
    required this.state,
    required this.label,
    this.showIcon = true,
    this.isStadiumBorder = true,
    super.key,
  });

  /// State used to determine the background colour, border, styles etc for the status.
  final AppCheckboxState state;

  /// Whether to show the icon.
  final bool showIcon;

  /// Whether to use a stadium border.
  final bool isStadiumBorder;

  /// Label to display.
  final String label;

  StatusTokens _getStatusTokens(AppTheme theme) {
    switch (state) {
      case AppCheckboxState.checked:
        return theme.statusDone;
      case AppCheckboxState.intermediate:
        return theme.statusInProgress;
      case AppCheckboxState.unchecked:
        return theme.statusTodo;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    final statusTokens = _getStatusTokens(colors);

    final padding = isStadiumBorder
        ? EdgeInsets.all(spacing.xs)
        : EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xxs);

    final shape = isStadiumBorder
        ? StadiumBorder(side: BorderSide(color: statusTokens.border))
        : SmoothRectangleBorder(
            borderRadius: const SmoothBorderRadius.only(
              bottomLeft: SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
              topRight: SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
            ),
            side: BorderSide(
              color: statusTokens.border,
              width: 1.5,
            ),
          );

    final textStyle = isStadiumBorder
        ? fonts.text.sm.medium.copyWith(color: statusTokens.text)
        : fonts.text.xs.regular.copyWith(color: statusTokens.text);

    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: statusTokens.background,
        shape: shape,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon) ...[
            SvgPicture.asset(
              state.iconPath,
              height: 16,
              width: 16,
              colorFilter: ColorFilter.mode(
                statusTokens.text,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
