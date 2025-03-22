import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../../design_system/icons/app_icons.dart';
import '../../design_system/themes/base/semantics/task_detail_overview_tile_token.dart';
import '../buttons/clickable_svg.dart';

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
    this.onValueTap,
    this.overlayChildBuilder,
  });

  final String label;
  final IconData labelIcon;
  final Widget? value;
  final String valuePlaceholder;
  final bool isRemovable;
  final VoidCallback? onRemove;

  /// Called when the value section of the tile is clicked.
  /// The [position] parameter contains the global offset of the tile from the top-left corner.
  /// The [controller] parameter contains the controller of the overlay portal.
  /// Either of one should be used.
  final void Function(Offset position, OverlayPortalController controller)? onValueTap;

  /// Optional builder for overlay child content.
  /// Use this to build custom overlay content when the tile is tapped.
  /// The controller parameter gives access to the OverlayPortalController.
  final Widget Function(BuildContext context, OverlayPortalController controller)?
      overlayChildBuilder;
}

class SelectedValueWidget extends ConsumerWidget {
  const SelectedValueWidget({
    required this.label,
    super.key,
    this.icon,
  });

  final IconData? icon;
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
        if (icon != null)
          AppIconButton(
            icon: icon!,
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
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _PropertyTileLabel(data: data),
        ),
        Expanded(
          flex: 8,
          child: _PropertyTileValue(data: data),
        ),
      ],
    );
  }
}

class _PropertyTileValue extends ConsumerStatefulWidget {
  const _PropertyTileValue({
    required this.data,
  });

  final PropertyData data;

  @override
  ConsumerState<_PropertyTileValue> createState() => _PropertyTileValueState();
}

class _PropertyTileValueState extends ConsumerState<_PropertyTileValue> {
  final _key = GlobalKey();
  late final _controller = OverlayPortalController();

  void _handleTap() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      widget.data.onValueTap?.call(position, _controller);
    } else {
      widget.data.onValueTap?.call(Offset.zero, _controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ref.watch(spacingProvider);
    final color = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final hasValue = widget.data.value != null;

    final theme =
        hasValue ? color.textDetailOverviewTileHasValue : color.textDetailOverviewTileNoValue;

    return GestureDetector(
      key: _key,
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (context) {
          return widget.data.overlayChildBuilder != null
              ? widget.data.overlayChildBuilder!(context, _controller)
              : const SizedBox.shrink();
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: spacing.sm),
                alignment: Alignment.centerLeft,
                child: hasValue
                    ? widget.data.value
                    : _placeholderWidget(
                        fonts: fonts,
                        color: theme,
                        ref: ref,
                      ),
              ),
            ),
            if (widget.data.value != null && widget.data.isRemovable)
              AppIconButton(
                icon: AppIcons.xmark,
                size: 20,
                color: color.textTokens.tertiary,
                onClick: widget.data.onRemove,
              ),
          ],
        ),
      ),
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
          widget.data.valuePlaceholder,
          style: fonts.text.sm.regular.copyWith(
            color: color.valueForeground,
          ),
        ),
        AppIconButton(
          icon: AppIcons.chevronDown,
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
            icon: data.labelIcon,
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
