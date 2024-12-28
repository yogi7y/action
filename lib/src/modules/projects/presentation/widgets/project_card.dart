import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/assets/assets_constants.dart';
import '../../../../design_system/spacing/spacing.dart';
import '../../../../design_system/themes/base/theme.dart';
import '../../../../design_system/typography/typography.dart';
import '../../../../shared/buttons/icon_button.dart';
import '../state/projects_provider.dart';

@immutable
class ProjectCard extends ConsumerWidget {
  const ProjectCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _project = ref.watch(scopedProjectProvider);
    final _colors = ref.watch(appThemeProvider);
    final _projectCardTheme = ref.watch(appThemeProvider).projectCard;
    final _spacing = ref.watch(spacingProvider);
    final _fonts = ref.watch(fontsProvider);
    const _borderRadiusValue = 12.0;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: _projectCardTheme.background,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: _borderRadiusValue,
            cornerSmoothing: 1,
          ),
        ),
        shadows: [
          BoxShadow(
            offset: const Offset(0, 8),
            blurRadius: 36,
            color: _projectCardTheme.shadow,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: ShapeDecoration(
                    color: _projectCardTheme.headerBackground,
                    shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.vertical(
                        top: SmoothRadius(cornerRadius: _borderRadiusValue, cornerSmoothing: 1),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(_spacing.xs),
                    decoration: ShapeDecoration(
                      color: _colors.statusInProgress.background,
                      shape: SmoothRectangleBorder(
                        borderRadius: const SmoothBorderRadius.only(
                          bottomLeft:
                              SmoothRadius(cornerRadius: _borderRadiusValue, cornerSmoothing: 1),
                          topRight:
                              SmoothRadius(cornerRadius: _borderRadiusValue, cornerSmoothing: 1),
                        ),
                        side: BorderSide(
                          color: _colors.statusInProgress.border,
                        ),
                      ),
                    ),
                    child: Text(
                      'In Progress',
                      style: _fonts.text.xs.regular.copyWith(
                        color: _colors.statusInProgress.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(_spacing.xs).copyWith(bottom: _spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _project.name,
                  style: _fonts.text.sm.medium.copyWith(
                    color: _projectCardTheme.titleForeground,
                  ),
                ),
                SizedBox(height: _spacing.xs),
                const _IconWithText(
                  label: '14th Jan, 2025',
                  iconPath: Assets.calendarMonth,
                ),
                SizedBox(height: _spacing.xs),
                const Row(
                  children: [
                    _IconWithText(
                      label: '14/16',
                      iconPath: Assets.addTask,
                    ),
                    Spacer(),
                    _IconWithText(
                      label: '12',
                      iconPath: Assets.bookmarkAdd,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class _IconWithText extends ConsumerWidget {
  const _IconWithText({required this.label, required this.iconPath});

  final String label;
  final String iconPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _projectCardTheme = _colors.projectCard;
    final _fonts = ref.watch(fontsProvider);
    final _spacing = ref.watch(spacingProvider);
    return Row(
      children: [
        AppIconButton(
          svgIconPath: iconPath,
          color: _projectCardTheme.subtitleForeground,
          size: 16,
        ),
        SizedBox(width: _spacing.xxs),
        Text(
          label,
          style: _fonts.text.xs.medium.copyWith(
            color: _projectCardTheme.subtitleForeground,
            height: 1,
          ),
        ),
      ],
    );
  }
}
