// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../design_system/design_system.dart';
import '../../../../shared/buttons/icon_button.dart';
import '../../../../shared/property_list/property_list.dart';
import '../../../../shared/status/status.dart';
import '../../../context/presentation/state/context_provider.dart';
import '../../../projects/presentation/state/projects_provider.dart';
import '../state/task_detail_provider.dart';

class TaskDetailProperties extends ConsumerWidget {
  const TaskDetailProperties({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final task = ref.watch(taskDetailNotifierProvider);

    final project = ref.watch(projectByIdProvider(task.projectId ?? ''));
    final context = ref.watch(contextByIdProvider(task.contextId ?? ''));

    final properties = <PropertyData>[
      PropertyData(
        label: 'Status',
        labelIcon: AssetsV2.loader,
        valuePlaceholder: 'Status is not set',
        value: StatusWidget(
          state: task.status.toAppCheckboxState(),
          label: task.status.displayStatus,
        ),
      ),
      PropertyData(
        label: 'Due',
        labelIcon: AssetsV2.calendar,
        valuePlaceholder: 'Empty',
        isRemovable: true,
        value: task.dueDate != null
            ? SelectedValueWidget(
                label: task.dueDate?.relativeDate ?? '',
              )
            : null,
      ),
      PropertyData(
        label: 'Project',
        labelIcon: AssetsV2.hammerOutlined,
        valuePlaceholder: 'Empty',
        isRemovable: true,
        value: project?.name != null
            ? SelectedValueWidget(
                iconPath: AssetsV2.hammerOutlined,
                label: project?.name ?? '',
              )
            : null,
      ),
      PropertyData(
        label: 'Context',
        labelIcon: AssetsV2.tag,
        valuePlaceholder: 'Empty',
        isRemovable: true,
        value: context?.name != null
            ? SelectedValueWidget(
                iconPath: AssetsV2.tag,
                label: context?.name ?? '',
              )
            : null,
      ),
    ];

    final footer = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          spacing: 2,
          children: [
            AppIconButton(
              svgIconPath: AssetsV2.clock,
              size: 12,
              color: colors.textTokens.tertiary,
            ),
            Text(
              task.createdAt.relativeDate,
              style: fonts.text.xs.regular.copyWith(
                color: colors.textTokens.tertiary,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dashed,
                decorationColor: colors.textTokens.tertiary.withValues(alpha: .6),
              ),
            ),
          ],
        )
      ],
    );

    return PropertyList(
      properties: properties,
      // footer: footer,
    );
  }
}

// class _SelectedValueWidget extends ConsumerWidget {
//   const _SelectedValueWidget({
//     required this.label,
//     this.iconPath,
//   });

//   final String? iconPath;
//   final String label;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _spacing = ref.watch(spacingProvider);
//     final _colors = ref.watch(appThemeProvider);
//     final _fonts = ref.watch(fontsProvider);

//     final _componentTheme = _colors.textDetailOverviewTileHasValue;

//     return Row(
//       spacing: _spacing.xxs,
//       children: [
//         if (iconPath != null)
//           AppIconButton(
//             svgIconPath: iconPath!,
//             size: 16,
//             color: _componentTheme.valueForeground,
//           ),
//         Text(
//           label,
//           style: _fonts.text.sm.medium.copyWith(
//             color: _componentTheme.valueForeground,
//           ),
//         ),
//       ],
//     );
//   }
// }

// @immutable
// class PropertyData {
//   const PropertyData({
//     required this.label,
//     required this.labelIcon,
//     required this.valuePlaceholder,
//     this.isRemovable = false,
//     this.onRemove,
//     this.value,
//   });

//   final String label;
//   final String labelIcon;
//   final Widget? value;
//   final String valuePlaceholder;

//   /// To decide whether to show the remove button or not
//   final bool isRemovable;
//   final VoidCallback? onRemove;
// }
