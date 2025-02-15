import 'dart:async';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/spacing.dart';
import '../../../../design_system/themes/base/theme.dart';
import '../../../../design_system/typography/typography.dart';
import '../../../../shared/buttons/clickable_svg.dart';
import '../../../../shared/status/status.dart';
import '../state/projects_provider.dart';

@immutable
class ProjectCard extends ConsumerWidget {
  const ProjectCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectViewModel = ref.watch(scopedProjectProvider);
    final project = projectViewModel.project;
    final relationMetaData = projectViewModel.metadata;
    final projectCardTheme = ref.watch(appThemeProvider).projectCard;
    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);
    const borderRadiusValue = 12.0;

    return GestureDetector(
      onTap: () => unawaited(
        context.pushNamed(
          AppRoute.projectDetail.name,
          pathParameters: {'id': project.id},
          extra: projectViewModel,
        ),
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: projectCardTheme.background,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: borderRadiusValue,
              cornerSmoothing: 1,
            ),
          ),
          shadows: [
            BoxShadow(
              offset: const Offset(0, 8),
              blurRadius: 36,
              color: projectCardTheme.shadow,
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
                      color: projectCardTheme.headerBackground,
                      shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.vertical(
                          top: SmoothRadius(cornerRadius: borderRadiusValue, cornerSmoothing: 1),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: StatusWidget(
                      state: project.status.toAppCheckboxState(),
                      label: project.status.displayStatus,
                      showIcon: false,
                      isStadiumBorder: false,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(spacing.xs).copyWith(bottom: spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: fonts.text.sm.medium.copyWith(
                      color: projectCardTheme.titleForeground,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  const _IconWithText(
                    label: '14th Jan, 2025',
                    iconData: AppIcons.calendarLinesOutlined,
                  ),
                  SizedBox(height: spacing.xs),
                  Row(
                    children: [
                      _IconWithText(
                        label: relationMetaData?.totalTasks.toString() ?? '',
                        iconData: AppIcons.addTaskOutlined,
                      ),
                      const Spacer(),
                      _IconWithText(
                        label: relationMetaData?.totalPages.toString() ?? '',
                        iconData: AppIcons.bookmarkAddOutlined,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class _IconWithText extends ConsumerWidget {
  const _IconWithText({required this.label, required this.iconData});

  final String label;
  final IconData iconData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final projectCardTheme = colors.projectCard;
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);
    return Row(
      children: [
        AppIconButton(
          icon: iconData,
          color: projectCardTheme.subtitleForeground,
          size: 16,
        ),
        SizedBox(width: spacing.xxs),
        Text(
          label,
          style: fonts.text.xs.medium.copyWith(
            color: projectCardTheme.subtitleForeground,
            height: 1,
          ),
        ),
      ],
    );
  }
}
