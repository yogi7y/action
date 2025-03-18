import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/router.dart';
import '../../../../core/router/routes.dart';
import '../../../../design_system/themes/base/theme.dart';
import '../../../../design_system/typography/typography.dart';
import '../../domain/use_case/auth_use_case.dart';

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
    final authUseCase = ref.read(authUseCaseProvider);
    final router = ref.read(routerProvider);

    if (authUseCase.isSignedIn) {
      router.goNamed(AppRoute.home.name);
    } else {
      router.goNamed(AppRoute.auth.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);

    return Scaffold(
      backgroundColor: colors.surface.background,
      body: Center(
        child: Text(
          'Splash Screen',
          style: fonts.headline.md.semibold,
        ),
      ),
    );
  }
}
