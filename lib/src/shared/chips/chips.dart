import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../design_system/spacing/spacing.dart';
import '../../design_system/typography/typography.dart';
import '../../modules/dashboard/presentation/state/app_theme.dart';

class AppChips extends ConsumerWidget {
  const AppChips({
    required this.label,
    required this.iconPath,
    this.count = 0,
    this.isSelected = false,
    super.key,
  });

  final bool isSelected;
  final String label;
  final int count;
  final String iconPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _spacing = ref.watch(spacingProvider);
    final _fonts = ref.watch(fontsProvider);

    final _chipsTheme = isSelected ? _colors.selectedChips : _colors.unselectedChips;
    final _labelStyle = isSelected ? _fonts.text.md.semibold : _fonts.text.md.regular;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing.md,
        vertical: _spacing.xs,
      ),
      decoration: BoxDecoration(
        color: _chipsTheme.background,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        spacing: _spacing.xs,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 16,
            width: 16,
          ),
          Text(
            label,
            style: _labelStyle.copyWith(color: _chipsTheme.text),
          ),
          if (count > 0)
            Text(
              count.toString(),
              style: _fonts.text.sm.regular.copyWith(
                color: _chipsTheme.text,
              ),
            ),
        ],
      ),
    );
  }
}
