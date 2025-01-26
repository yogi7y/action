import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../buttons/icon_button.dart';

class AppSelectableChip extends ConsumerWidget {
  const AppSelectableChip({
    required this.label,
    this.iconPath,
    this.value,
    super.key,
    this.onClick,
    this.onCrossClick,
  });

  final String? iconPath;
  final String label;
  final String? value;
  final VoidCallback? onClick;
  final VoidCallback? onCrossClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    final hasValue = value != null && value!.isNotEmpty;

    final selectableChipTheme =
        hasValue ? colors.selectableChipsSelected : colors.selectableChipsUnselected;

    final labelOrValue = hasValue ? value ?? '' : label;
    final textStyle = hasValue ? fonts.text.sm.semibold : fonts.text.sm.regular;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.xs,
          vertical: spacing.xxs + 2,
        ),
        decoration: ShapeDecoration(
          // color: _selectableChipTheme.fillColor,
          color: colors.surface.background,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 8),
            side: BorderSide(color: selectableChipTheme.border),
          ),
        ),
        child: Row(
          children: [
            if (iconPath != null && iconPath!.isNotEmpty) ...{
              AppIconButton(
                svgIconPath: iconPath!,
                color: selectableChipTheme.foregroundColor,
                size: 16,
              ),
              SizedBox(width: spacing.xxs),
            },
            Text(
              labelOrValue,
              style: textStyle.copyWith(
                color: selectableChipTheme.foregroundColor,
              ),
            ),
            SizedBox(width: spacing.xxs),
            if (hasValue)
              AppIconButton(
                svgIconPath: AssetsV2.xmark,
                onClick: onCrossClick,
                size: 16,
                color: selectableChipTheme.foregroundColor.withValues(alpha: .8),
              )
          ],
        ),
      ),
    );
  }
}
