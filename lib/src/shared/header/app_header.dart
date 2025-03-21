import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../../design_system/icons/app_icons.dart';
import '../buttons/clickable_svg.dart';

class AppHeader extends ConsumerWidget {
  const AppHeader({
    required this.title,
    this.isSliver = false,
    super.key,
  });

  final String title;
  final bool isSliver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = ref.watch(spacingProvider);
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);

    const leadingWidth = 0.0;
    const elevation = 0.0;
    final titleSpacing = spacing.lg;
    final toolbarHeight = kToolbarHeight + spacing.md;
    final backgroundColor = colors.surface.background;
    const shadowColor = Colors.transparent;
    const automaticallyImplyLeading = false;
    final titleTextStyle = fonts.headline.lg.semibold;
    final actions = [
      IconButton(
        onPressed: () {},
        icon: AppIconButton(icon: AppIcons.search, size: 24, color: colors.textTokens.primary),
      ),
    ];

    return isSliver
        ? SliverAppBar(
            pinned: true,
            leadingWidth: leadingWidth,
            elevation: elevation,
            titleSpacing: titleSpacing,
            shadowColor: shadowColor,
            automaticallyImplyLeading: automaticallyImplyLeading,
            toolbarHeight: toolbarHeight,
            backgroundColor: backgroundColor,
            title: Text(title, style: titleTextStyle),
            actions: actions,
          )
        : AppBar(
            leadingWidth: leadingWidth,
            elevation: elevation,
            titleSpacing: titleSpacing,
            backgroundColor: backgroundColor,
            title: Text(title, style: titleTextStyle),
            actions: actions,
          );
  }
}
