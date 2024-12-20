import 'package:flutter/material.dart';

import 'modules/dashboard/presentation/dashboard_screen.dart';

@immutable
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DashboardScreen(),
    );
  }
}
