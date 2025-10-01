import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../design_system/design_system.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/buttons/clickable_svg.dart';
import '../../../../shared/header/app_header.dart';
import '../sections/action_center.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);

    return Scaffold(
      backgroundColor: colors.surface.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            AppHeader(
              title: 'Home',
              actions: [
                IconButton(
                  onPressed: () {
                    unawaited(context.pushNamed(AppRoute.inbox.name));
                  },
                  icon: AppIconButton(
                    icon: AppIcons.area,
                    size: 24,
                    color: colors.textTokens.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
