import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';

class PickerItem extends ConsumerWidget {
  const PickerItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.onRemove,
    super.key,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.overlay.borderStroke.withValues(alpha: .3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: colors.textTokens.secondary,
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Text(
                title,
                style: fonts.text.sm.medium.copyWith(
                  color: colors.textTokens.primary,
                ),
              ),
            ),
            if (isSelected && onRemove != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onRemove,
                child: Icon(
                  Icons.clear,
                  size: 20,
                  color: colors.textTokens.tertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PickerEmptyState extends ConsumerWidget {
  const PickerEmptyState({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Text(
          message,
          style: fonts.text.md.regular.copyWith(
            color: colors.textTokens.secondary,
          ),
        ),
      ),
    );
  }
}
