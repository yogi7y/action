import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../buttons/clickable_svg.dart';

class AppChips extends ConsumerWidget {
  const AppChips({
    required this.label,
    this.icon,
    this.count = 0,
    this.isSelected = false,
    this.onClick,
    super.key,
  });

  final bool isSelected;
  final String label;
  final int count;
  final IconData? icon;
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
            if (icon != null)
              AppIconButton(
                icon: icon!,
                size: 16,
                color: chipsTheme.text,
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
