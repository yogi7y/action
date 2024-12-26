import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../design_system/themes/base/theme.dart';
import '../../../../design_system/typography/typography.dart';
import '../../domain/use_case/auth_use_case.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthState();
    });
  }

  void _checkAuthState() {
    final _authUseCase = ref.read(authUseCaseProvider);

    final _router = AutoRouter.of(context);
    if (_authUseCase.isSignedIn) {
      unawaited(_router.push(const DashboardRoute()));
    } else {
      unawaited(_router.push(const AuthenticationRoute()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    return Scaffold(
      backgroundColor: _colors.surface.background,
      body: Center(
        child: Text(
          'Splash Screen',
          style: _fonts.headline.md.semibold,
        ),
      ),
    );
  }
}
