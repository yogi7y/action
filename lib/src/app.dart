import 'package:flutter/material.dart';

import 'design_system/typography/mobile_fonts.dart';
import 'modules/authentication/presentation/splash_screen.dart';

@immutable
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(
        fontFamily: interFontFamily,
      ),
    );
  }
}
