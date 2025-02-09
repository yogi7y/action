import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../design_system/design_system.dart';

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
          icon: SvgPicture.asset(
            AssetsV2.search,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(colors.textTokens.primary, BlendMode.srcIn),
          ),
        ),
        SizedBox(width: spacing.xs),
      ],
    );
  }
}
