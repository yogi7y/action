import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../design_system/design_system.dart';

class AppChips extends ConsumerWidget {
  const AppChips({
    required this.label,
    required this.iconPath,
    this.count = 0,
    this.isSelected = false,
    this.onClick,
    super.key,
  });

  final bool isSelected;
  final String label;
  final int count;
  final String iconPath;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);

    final chipsTheme = isSelected ? colors.selectedChips : colors.unselectedChips;
    final labelStyle = isSelected ? fonts.text.md.semibold : fonts.text.md.regular;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: chipsTheme.background,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          spacing: spacing.xs,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 16,
              width: 16,
              colorFilter: ColorFilter.mode(chipsTheme.text, BlendMode.srcIn),
            ),
            Text(
              label,
              style: labelStyle.copyWith(color: chipsTheme.text),
            ),
            if (count > 0)
              Text(
                count.toString(),
                style: fonts.text.sm.regular.copyWith(
                  color: chipsTheme.text,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
