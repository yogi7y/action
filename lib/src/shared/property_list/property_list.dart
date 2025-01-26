import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../../design_system/themes/base/semantics/task_detail_overview_tile_token.dart';
import '../buttons/icon_button.dart';

class PropertyList extends ConsumerWidget {
  const PropertyList({
    required this.properties,
    super.key,
  });

  final List<PropertyData> properties;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    final colors = ref.watch(appThemeProvider);

    return ColoredBox(
      color: colors.l2Screen.background,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: spacing.lg),
        child: Column(
          children: [
            Column(
              children: List.generate(
                properties.length,
                (index) {
                  final property = properties[index];
                  final componentTheme = property.value != null
                      ? colors.textDetailOverviewTileHasValue
                      : colors.textDetailOverviewTileNoValue;

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: index == properties.length - 1
                            ? BorderSide.none
                            : BorderSide(
                                color: componentTheme.border,
                                width: .7,
                              ),
                      ),
                    ),
                    child: _PropertyTile(data: property),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyData {
  const PropertyData({
    required this.label,
    required this.labelIcon,
    required this.valuePlaceholder,
    this.isRemovable = false,
    this.onRemove,
    this.value,
    this.onTap,
  });

  final String label;
  final String labelIcon;
  final Widget? value;
  final String valuePlaceholder;
  final bool isRemovable;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;
}

class SelectedValueWidget extends ConsumerWidget {
  const SelectedValueWidget({
    required this.label,
    super.key,
    this.iconPath,
  });

  final String? iconPath;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);

    final componentTheme = colors.textDetailOverviewTileHasValue;

    return Row(
      spacing: spacing.xxs,
      children: [
        if (iconPath != null)
          AppIconButton(
            svgIconPath: iconPath!,
            size: 16,
            color: componentTheme.valueForeground,
          ),
        Text(
          label,
          style: fonts.text.sm.medium.copyWith(
            color: componentTheme.valueForeground,
          ),
        ),
      ],
    );
  }
}

class _PropertyTile extends ConsumerWidget {
  const _PropertyTile({
    required this.data,
  });

  final PropertyData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: data.onTap,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _PropertyTileLabel(
              data: data,
            ),
          ),
          Expanded(
            flex: 8,
            child: _PropertyTileValue(data: data),
          ),
        ],
      ),
    );
  }
}

class _PropertyTileValue extends ConsumerWidget {
  const _PropertyTileValue({
    required this.data,
  });

  final PropertyData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    final color = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final hasValue = data.value != null;

    final theme =
        hasValue ? color.textDetailOverviewTileHasValue : color.textDetailOverviewTileNoValue;

    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: spacing.sm),
            alignment: Alignment.centerLeft,
            child: hasValue
                ? data.value
                : _placeholderWidget(
                    fonts: fonts,
                    color: theme,
                    ref: ref,
                  ),
          ),
        ),
        if (data.value != null && data.isRemovable)
          AppIconButton(
            svgIconPath: AssetsV2.xmark,
            size: 20,
            color: color.textTokens.tertiary,
            onClick: data.onRemove,
          ),
      ],
    );
  }

  Widget _placeholderWidget({
    required Fonts fonts,
    required TextDetailOverviewTileTokens color,
    required WidgetRef ref,
  }) {
    final colors = ref.watch(appThemeProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          data.valuePlaceholder,
          style: fonts.text.sm.regular.copyWith(
            color: color.valueForeground,
          ),
        ),
        AppIconButton(
          svgIconPath: AssetsV2.chevronDown,
          size: 20,
          color: colors.textTokens.tertiary,
        )
      ],
    );
  }
}

class _PropertyTileLabel extends ConsumerWidget {
  const _PropertyTileLabel({
    required this.data,
  });
  final PropertyData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);

    final theme = data.value != null
        ? colors.textDetailOverviewTileHasValue
        : colors.textDetailOverviewTileNoValue;

    return Container(
      padding: EdgeInsets.symmetric(vertical: spacing.sm),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: theme.border, width: .7)),
      ),
      child: Row(
        spacing: spacing.xxs,
        children: [
          AppIconButton(
            svgIconPath: data.labelIcon,
            color: theme.labelForeground.withValues(alpha: .8),
            size: 16,
          ),
          Text(
            data.label,
            style:
                fonts.text.sm.regular.copyWith(color: theme.labelForeground.withValues(alpha: .8)),
          ),
        ],
      ),
    );
  }
}
