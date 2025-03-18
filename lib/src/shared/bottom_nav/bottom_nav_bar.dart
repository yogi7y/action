import 'package:collection/collection.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../buttons/clickable_svg.dart';
import 'bottom_nav_items_provider.dart';

@immutable
class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final items = ref.watch(bottomNavItemsProvider);
    final selectedItem = ref.watch(selectedBottomNavProvider);

    return UnconstrainedBox(
      child: Container(
        decoration: BoxDecoration(
          color: colors.unselectedBottomNavigationItem.background,
          boxShadow: [
            BoxShadow(
              color: colors.surface.backgroundContrast.withValues(alpha: .2),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: items
              .mapIndexed((index, item) => Expanded(
                    child: GestureDetector(
                      onTap: () => _onTap(index: index, data: item, ref: ref),
                      child: BottomNavItem(
                        data: item,
                        isSelected: item == selectedItem.item,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _onTap({
    required int index,
    required BottomNavItemData data,
    required WidgetRef ref,
  }) {
    ref.read(navigatorShellProvider).goBranch(index);
  }
}

class BottomNavItem extends ConsumerWidget {
  const BottomNavItem({
    required this.data,
    this.isSelected = false,
    super.key,
  });

  final BottomNavItemData data;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    final backgroundColor = isSelected
        ? colors.selectedBottomNavigationItem.background
        : colors.unselectedBottomNavigationItem.background;

    final labelStyle = isSelected
        ? fonts.text.xs.semibold.copyWith(
            color: colors.selectedBottomNavigationItem.text,
          )
        : fonts.text.xs.medium.copyWith(
            color: colors.unselectedBottomNavigationItem.text,
          );

    return Container(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: isSelected ? 8 : 0, cornerSmoothing: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: spacing.sm,
      ),
      child: Column(
        children: [
          AppIconButton(
            icon: data.icon,
            color: isSelected
                ? colors.selectedBottomNavigationItem.text
                : colors.unselectedBottomNavigationItem.text,
          ),
          SizedBox(height: spacing.xxs),
          Text(
            data.label,
            style: labelStyle,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
