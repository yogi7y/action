import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../design_system/design_system.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/buttons/clickable_svg.dart';
import '../sections/action_center.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);

    return Scaffold(
      backgroundColor: colors.surface.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: spacing.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppIconButton(
                      icon: AppIcons.houseSmile,
                      size: 24,
                      color: colors.textTokens.primary,
                      onClick: () {},
                    ),
                    Row(
                      children: [
                        AppIconButton(
                          icon: AppIcons.resources,
                          size: 24,
                          color: colors.textTokens.primary,
                          onClick: () => unawaited(context.pushNamed(AppRoute.inbox.name)),
                        ),
                        SizedBox(width: spacing.md),
                        AppIconButton(
                          icon: AppIcons.userOutlined,
                          size: 24,
                          color: colors.textTokens.primary,
                          onClick: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.xxl),
              const ActionCenter(),
            ],
          ),
        ),
      ),
    );
  }
}
