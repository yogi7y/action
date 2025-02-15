import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../../design_system/icons/app_icons.dart';
import '../buttons/clickable_svg.dart';

class AppHeader extends ConsumerWidget {
  const AppHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);

    return SliverAppBar(
      leadingWidth: 0,
      pinned: true,
      elevation: 0,
      titleSpacing: spacing.lg,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight + spacing.md,
      backgroundColor: colors.surface.background,
      title: Text(
        title,
        style: fonts.headline.lg.semibold,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: AppIconButton(
            icon: AppIcons.search,
            size: 24,
            color: colors.textTokens.primary,
          ),
        ),
        SizedBox(width: spacing.xs),
      ],
    );
  }
}
