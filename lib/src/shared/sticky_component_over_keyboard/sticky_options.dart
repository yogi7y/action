import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../chips/selectable_chip.dart';
import 'sticky_keyboard_provider.dart';

@immutable
class StickyOptions extends ConsumerWidget {
  const StickyOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    return Row(
      spacing: _spacing.xs,
      children: [
        AppSelectableChip(
          iconPath: Assets.construction,
          label: 'Project',
          onClick: () {
            ref.read(showProjectStickyTextFieldProvider.notifier).update((_) => true);
          },
        ),
        AppSelectableChip(
          iconPath: Assets.tag,
          label: 'Context',
          onClick: () {
            ref.read(showContextStickyTextFieldProvider.notifier).update((_) => true);
          },
        ),
        AppSelectableChip(
          iconPath: Assets.calendarMonth,
          label: 'Due Date',
          onClick: () {},
        ),
      ],
    );
  }
}
