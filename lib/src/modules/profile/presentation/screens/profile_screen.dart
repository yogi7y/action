import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/buttons/async_button.dart';
import '../../../dashboard/presentation/state/app_theme.dart';

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);

    return Scaffold(
      backgroundColor: _colors.surface.background,
      body: Center(
        child: AsyncButton(
          text: 'Change Theme',
          onClick: () async => ref.read(appThemeProvider.notifier).toggle(),
        ),
      ),
    );
  }
}
