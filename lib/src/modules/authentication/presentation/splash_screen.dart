import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../design_system/themes/base/theme.dart';
import '../../../design_system/typography/typography.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(colorsProvider);
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
