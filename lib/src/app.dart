import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/env/flavor.dart';
import 'core/logger/logger.dart';
import 'core/mixin/keyboard_mixin.dart';
import 'core/router/router.dart';
import 'design_system/design_system.dart';
import 'design_system/typography/mobile_fonts.dart';
import 'modules/dashboard/presentation/state/status_bar_theme_provider.dart';

@immutable
class App extends ConsumerWidget with KeyboardMixin {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _appFlavor = ref.watch(appFlavorProvider);
    final _router = ref.watch(routerProvider);

    ref.watch(systemUiControllerProvider);

    return MaterialApp.router(
      routerConfig: _router,
      title: _appFlavor.appName,
      theme: ThemeData(
        fontFamily: interFontFamily,
        scaffoldBackgroundColor: _colors.surface.background,
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
