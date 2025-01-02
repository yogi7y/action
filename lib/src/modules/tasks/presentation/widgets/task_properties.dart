// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../design_system/design_system.dart';
import '../../../../design_system/themes/base/semantics/task_detail_overview_tile_token.dart';
import '../../../../shared/buttons/icon_button.dart';
import '../../../../shared/status/status.dart';
import '../../../context/presentation/state/context_provider.dart';
import '../../../projects/presentation/state/projects_provider.dart';
import '../state/task_detail_provider.dart';

class TaskProperties extends ConsumerWidget {
  const TaskProperties({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _task = ref.watch(scopedTaskDetailProvider);

    final _project = ref.watch(projectByIdProvider(_task.projectId ?? ''));
    final _context = ref.watch(contextByIdProvider(_task.contextId ?? ''));

    final _properties = <PropertyTileData>[
      const PropertyTileData(
        label: 'Status',
        labelIcon: AssetsV2.loader,
        valuePlaceholder: 'Status is not set',
        value: StatusWidget(status: StatusType.inProgress),
      ),
      PropertyTileData(
        label: 'Due',
        labelIcon: AssetsV2.calendar,
        valuePlaceholder: 'Empty',
        isRemovable: true,
        value: _task.dueDate != null
            ? _SelectedValueWidget(
                label: _task.dueDate?.relativeDate ?? '',
              )
            : null,
      ),
      PropertyTileData(
        label: 'Project',
        labelIcon: AssetsV2.hammerOutlined,
        valuePlaceholder: 'Empty',
        isRemovable: true,
        value: _project?.name != null
            ? _SelectedValueWidget(
                iconPath: AssetsV2.hammerOutlined,
                label: _project?.name ?? '',
              )
            : null,
      ),
      PropertyTileData(
        label: 'Context',
        labelIcon: AssetsV2.tag,
        valuePlaceholder: 'Empty',
        isRemovable: true,
        value: _context?.name != null
            ? _SelectedValueWidget(
                iconPath: AssetsV2.tag,
                label: _context?.name ?? '',
              )
            : null,
      ),
    ];

    return ColoredBox(
      color: _colors.l2Screen.background,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: _spacing.lg),
        child: Column(
          children: [
            Column(
              children: List.generate(
                _properties.length,
                (index) {
                  final _property = _properties[index];

                  final _componentTheme = _property.value != null
                      ? _colors.textDetailOverviewTileHasValue
                      : _colors.textDetailOverviewTileNoValue;

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: index == _properties.length - 1
                            ? BorderSide.none
                            : BorderSide(
                                color: _componentTheme.border,
                                width: .7,
                              ),
                      ),
                    ),
                    child: _PropertyTile(data: _property),
                  );
                },
              ),
            ),
            SizedBox(height: _spacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  spacing: 2,
                  children: [
                    AppIconButton(
                      svgIconPath: AssetsV2.clock,
                      size: 12,
                      color: _colors.textTokens.tertiary,
                    ),
                    Text(
                      _task.createdAt.relativeDate,
                      style: _fonts.text.xs.regular.copyWith(
                        color: _colors.textTokens.tertiary,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dashed,
                        decorationColor: _colors.textTokens.tertiary.withValues(alpha: .6),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _SelectedValueWidget extends ConsumerWidget {
  const _SelectedValueWidget({
    required this.label,
    this.iconPath,
  });

  final String? iconPath;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    final _componentTheme = _colors.textDetailOverviewTileHasValue;

    return Row(
      spacing: _spacing.xxs,
      children: [
        if (iconPath != null)
          AppIconButton(
            svgIconPath: iconPath!,
            size: 16,
            color: _componentTheme.valueForeground,
          ),
        Text(
          label,
          style: _fonts.text.sm.medium.copyWith(
            color: _componentTheme.valueForeground,
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

  final PropertyTileData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
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
    );
  }
}

class _PropertyTileValue extends ConsumerWidget {
  const _PropertyTileValue({
    required this.data,
  });

  final PropertyTileData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _color = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _hasValue = data.value != null;

    final _theme =
        _hasValue ? _color.textDetailOverviewTileHasValue : _color.textDetailOverviewTileNoValue;

    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: _spacing.sm),
            alignment: Alignment.centerLeft,
            child: _hasValue
                ? data.value
                : _placeholderWidget(
                    fonts: _fonts,
                    color: _theme,
                    ref: ref,
                  ),
          ),
        ),
        if (data.value != null && data.isRemovable)
          AppIconButton(
            svgIconPath: AssetsV2.xmark,
            size: 20,
            color: _color.textTokens.tertiary,
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
    final _colors = ref.watch(appThemeProvider);
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
          color: _colors.textTokens.tertiary,
        )
      ],
    );
  }
}

class _PropertyTileLabel extends ConsumerWidget {
  const _PropertyTileLabel({
    required this.data,
  });
  final PropertyTileData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    final _theme = data.value != null
        ? _colors.textDetailOverviewTileHasValue
        : _colors.textDetailOverviewTileNoValue;

    return Container(
      padding: EdgeInsets.symmetric(vertical: _spacing.sm),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: _theme.border, width: .7)),
      ),
      child: Row(
        spacing: _spacing.xxs,
        children: [
          AppIconButton(
            svgIconPath: data.labelIcon,
            color: _theme.labelForeground.withValues(alpha: .8),
            size: 16,
          ),
          Text(
            data.label,
            style: _fonts.text.sm.regular
                .copyWith(color: _theme.labelForeground.withValues(alpha: .8)),
          ),
        ],
      ),
    );
  }
}

@immutable
class PropertyTileData {
  const PropertyTileData({
    required this.label,
    required this.labelIcon,
    required this.valuePlaceholder,
    this.isRemovable = false,
    this.onRemove,
    this.value,
  });

  final String label;
  final String labelIcon;
  final Widget? value;
  final String valuePlaceholder;

  /// To decide whether to show the remove button or not
  final bool isRemovable;
  final VoidCallback? onRemove;
}
