import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/env/flavor.dart';
import 'core/logger/logger.dart';
import 'core/mixin/keyboard_mixin.dart';
import 'core/router/router.dart';
import 'core/router/routes.dart';
import 'design_system/design_system.dart';
import 'design_system/typography/mobile_fonts.dart';
import 'modules/authentication/domain/use_case/auth_use_case.dart';
import 'modules/dashboard/presentation/state/status_bar_theme_provider.dart';

@immutable
class App extends ConsumerStatefulWidget with KeyboardMixin {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with KeyboardMixin {
  late final router = ref.watch(routerProvider);

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
    FlutterNativeSplash.remove();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appThemeProvider);
    final appFlavor = ref.watch(appFlavorProvider);

    ref.watch(systemUiControllerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: appFlavor.appName,
      theme: ThemeData(
        fontFamily: interFontFamily,
        scaffoldBackgroundColor: colors.surface.background,
      ),
      builder: (context, child) => PopScope(
        onPopInvokedWithResult: (didPop, result) {
          logger('onPopInvokedWithResult: $didPop, $result');
        },
        child: child!,
      ),
    );
  }
}
