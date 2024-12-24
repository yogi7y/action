import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'design_system/design_system.dart';
import 'design_system/typography/mobile_fonts.dart';

final _router = AppRouter();

@immutable
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    return MaterialApp.router(
      routerConfig: _router.config(),
      theme: ThemeData(
        fontFamily: interFontFamily,
        scaffoldBackgroundColor: _colors.surface.background,
      ),
    );
  }
}
