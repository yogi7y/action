// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../buttons/icon_button.dart';

@immutable
class ChipTabBar extends ConsumerStatefulWidget {
  const ChipTabBar({
    required this.items,
    required this.pageController,
    this.onTabChanged,
    this.selectedIndex = 0,
    super.key,
  });

  final List<ChipTabBarItem> items;
  final void Function(int index)? onTabChanged;
  final int selectedIndex;
  final PageController pageController;

  @override
  ConsumerState<ChipTabBar> createState() => _ChipTabBarState();
}

class _ChipTabBarState extends ConsumerState<ChipTabBar> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    widget.pageController.addListener(_handlePageChange);
  }

  void _handlePageChange() {
    final page = widget.pageController.page ?? 0;
    _animationController.value = page;
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_handlePageChange);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);
    final _screenWidth = MediaQuery.of(context).size.width;
    final _tabWidth = (_screenWidth - (_spacing.lg * 2)) / widget.items.length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: _spacing.lg),
      decoration: ShapeDecoration(
        color: _colors.surface.modals,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: 9999, cornerSmoothing: 1),
        ),
      ),
      child: Stack(
        children: [
          Builder(builder: (context) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final _left = _animationController.value * _tabWidth;

                return Positioned(
                  top: 0,
                  left: _left,
                  bottom: 0,
                  child: Container(
                    width: _tabWidth,
                    decoration: ShapeDecoration(
                      color: _colors.primary,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 9999,
                          cornerSmoothing: 1,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          Row(
            children: widget.items
                .mapIndexed(
                  (index, item) => Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => widget.onTabChanged?.call(index),
                      child: TabBarChip(
                        label: item.label,
                        icon: item.icon,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

@immutable
class TabBarChip extends ConsumerWidget {
  const TabBarChip({
    required this.label,
    this.icon,
    super.key,
    this.isSelected = false,
  });

  final String label;
  final String? icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _fonts = ref.watch(fontsProvider);
    final _colors = ref.watch(appThemeProvider);
    final _primitiveTokens = ref.watch(primitiveTokensProvider);

    final _textColor = isSelected ? _primitiveTokens.white : _colors.textTokens.primary;

    return Container(
      decoration: ShapeDecoration(
        // color: _backgroundColor,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: 9999, cornerSmoothing: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: _spacing.xs),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon?.isNotEmpty ?? false)
            Padding(
              padding: EdgeInsets.only(right: _spacing.xxs),
              child: AppIconButton(
                svgIconPath: icon!,
                size: 18,
              ),
            ),
          Text(
            label,
            style: _fonts.text.md.medium.copyWith(
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class ChipTabBarItem {
  const ChipTabBarItem({
    required this.label,
    this.icon,
  });
  final String label;
  final String? icon;

  @override
  String toString() => 'ChipTabBarItem(label: $label, icon: $icon)';

  @override
  bool operator ==(covariant ChipTabBarItem other) {
    if (identical(this, other)) return true;

    return other.label == label && other.icon == icon;
  }

  @override
  int get hashCode => label.hashCode ^ icon.hashCode;
}
