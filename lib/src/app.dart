import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'design_system/typography/mobile_fonts.dart';

@immutable
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final _router = AppRouter();

    return MaterialApp.router(
      routerConfig: _router.config(),
      theme: ThemeData(
        fontFamily: interFontFamily,
      ),
    );
  }
}
