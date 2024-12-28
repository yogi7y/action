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
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    return SliverAppBar(
      leadingWidth: 0,
      pinned: true,
      elevation: 0,
      titleSpacing: _spacing.lg,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight + _spacing.md,
      backgroundColor: _colors.surface.background,
      title: Text(
        title,
        style: _fonts.headline.lg.semibold,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            Assets.search,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(_colors.textTokens.primary, BlendMode.srcIn),
          ),
        ),
        SizedBox(width: _spacing.xs),
      ],
    );
  }
}
