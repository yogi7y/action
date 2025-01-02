import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/buttons/icon_button.dart';
import '../../../../shared/status/status.dart';

class TaskDetailHeaderOverviewTile extends ConsumerWidget {
  const TaskDetailHeaderOverviewTile({
    required this.iconPath,
    required this.label,
    super.key,
    this.value,
  });

  final String iconPath;
  final String label;
  final Widget? value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);

    final _hasValue = value != null;

    return Container(
      height: 36,
      margin: EdgeInsets.symmetric(horizontal: _spacing.lg),
      decoration: BoxDecoration(
        color: _colors.l2Screen.background,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _Label(
              iconPath: iconPath,
              label: label,
              hasValue: _hasValue,
            ),
          ),
          Expanded(
            flex: 7,
            child: Align(
              alignment: Alignment.centerLeft,
              child: UnconstrainedBox(child: value),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends ConsumerWidget {
  const _Label({
    required this.iconPath,
    required this.label,
    required this.hasValue,
  });

  final String iconPath;
  final String label;
  final bool hasValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    final _theme =
        hasValue ? _colors.textDetailOverviewTileHasValue : _colors.textDetailOverviewTileNoValue;

    return Row(
      children: [
        AppIconButton(
          svgIconPath: iconPath,
          size: 16,
          // color: _theme.labelForeground,
          color: _colors.textTokens.secondary,
        ),
        SizedBox(width: _spacing.xxs),
        Text(
          label,
          style: _fonts.text.md.regular.copyWith(
            color: _colors.textTokens.secondary,
          ),
        ),
      ],
    );
  }
}

class _Value extends ConsumerWidget {
  const _Value({
    required this.hasValue,
    this.value,
    this.valuePlaceholder,
  });

  final String? value;
  final String? valuePlaceholder;
  final bool hasValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _theme =
        hasValue ? _colors.textDetailOverviewTileHasValue : _colors.textDetailOverviewTileNoValue;

    final _border = BorderSide(color: _theme.border);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: value!.contains('Jan') ? BorderSide.none : _border,
          bottom: value == 'Work' ? BorderSide.none : _border,
        ),
      ),
      margin: const EdgeInsets.only(right: 20),
      padding: EdgeInsets.only(
        left: 8,
        top: _spacing.sm,
        bottom: _spacing.sm,
      ),
      child: Row(
        children: [
          StatusWidget(
            status: StatusType.inProgress,
            showIcon: false,
          )
          // Text(
          //   value ?? valuePlaceholder ?? '',
          //   style: _fonts.text.sm.medium.copyWith(
          //     color: _theme.valueForeground,
          //   ),
          // ),
        ],
      ),
    );
  }
}
