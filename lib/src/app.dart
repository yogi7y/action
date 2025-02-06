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
class App extends ConsumerStatefulWidget with KeyboardMixin {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with KeyboardMixin {
  late final router = ref.watch(routerProvider);

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
