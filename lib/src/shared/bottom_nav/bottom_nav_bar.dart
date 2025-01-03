import 'package:collection/collection.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../design_system/design_system.dart';
import 'bottom_nav_items_provider.dart';

@immutable
class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _items = ref.watch(bottomNavItemsProvider);
    final _selectedItem = ref.watch(selectedBottomNavProvider);

    return UnconstrainedBox(
      child: Container(
        decoration: BoxDecoration(
          color: _colors.unselectedBottomNavigationItem.background,
          boxShadow: [
            BoxShadow(
              color: _colors.surface.backgroundContrast.withValues(alpha: .2),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: _items
              .mapIndexed((index, item) => Expanded(
                    child: GestureDetector(
                      onTap: () => _onTap(index: index, data: item, ref: ref),
                      child: BottomNavItem(
                        data: item,
                        isSelected: item == _selectedItem.item,
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
    // ref.read(selectedBottomNavProvider.notifier).update((e) => (index: index, item: data));
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
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _spacing = ref.watch(spacingProvider);

    final _backgroundColor = isSelected
        ? _colors.selectedBottomNavigationItem.background
        : _colors.unselectedBottomNavigationItem.background;

    final _labelStyle = isSelected
        ? _fonts.text.xs.semibold.copyWith(
            color: _colors.selectedBottomNavigationItem.text,
          )
        : _fonts.text.xs.medium.copyWith(
            color: _colors.unselectedBottomNavigationItem.text,
          );

    return Container(
      decoration: ShapeDecoration(
        color: _backgroundColor,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: isSelected ? 8 : 0, cornerSmoothing: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: _spacing.sm,
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            data.iconPath,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? _colors.selectedBottomNavigationItem.text
                  : _colors.unselectedBottomNavigationItem.text,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: _spacing.xxs),
          Text(
            data.label,
            style: _labelStyle,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
