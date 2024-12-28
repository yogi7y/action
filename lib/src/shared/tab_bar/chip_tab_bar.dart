// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../buttons/icon_button.dart';

@immutable
class ChipTabBar extends ConsumerWidget {
  const ChipTabBar({
    required this.items,
    this.onTabChanged,
    this.selectedIndex = 0,
    super.key,
  });

  final List<ChipTabBarItem> items;
  final void Function(int index)? onTabChanged;
  final int selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _color = ref.watch(appThemeProvider);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: _spacing.lg),
      decoration: ShapeDecoration(
        color: _color.surface.modals,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: 9999, cornerSmoothing: 1),
        ),
      ),
      child: Row(
        children: items
            .mapIndexed((index, item) => TabBarChip(
                  label: item.label,
                  icon: item.icon,
                ))
            .toList(),
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
    final _backgroundColor = isSelected ? _colors.primary : _colors.surface.modals;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: ShapeDecoration(
            color: _backgroundColor,
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
        ),
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
