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
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _spacing = ref.watch(spacingProvider);

    final _hasValue = value != null && value!.isNotEmpty;

    final _selectableChipTheme =
        _hasValue ? _colors.selectableChipsSelected : _colors.selectableChipsUnselected;

    final _labelOrValue = _hasValue ? value ?? '' : label;
    final _textStyle = _hasValue ? _fonts.text.sm.semibold : _fonts.text.sm.regular;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _spacing.xs,
          vertical: _spacing.xxs + 2,
        ),
        decoration: ShapeDecoration(
          // color: _selectableChipTheme.fillColor,
          color: _colors.surface.background,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 8),
            side: BorderSide(color: _selectableChipTheme.border),
          ),
        ),
        child: Row(
          children: [
            if (iconPath != null && iconPath!.isNotEmpty) ...{
              AppIconButton(
                svgIconPath: iconPath!,
                color: _selectableChipTheme.foregroundColor,
                size: 16,
              ),
              SizedBox(width: _spacing.xxs),
            },
            Text(
              _labelOrValue,
              style: _textStyle.copyWith(
                color: _selectableChipTheme.foregroundColor,
              ),
            ),
            SizedBox(width: _spacing.xxs),
            if (_hasValue)
              AppIconButton(
                svgIconPath: AssetsV2.xmark,
                onClick: onCrossClick,
                size: 16,
                color: _selectableChipTheme.foregroundColor.withValues(alpha: .8),
              )
          ],
        ),
      ),
    );
  }
}
