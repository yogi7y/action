import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/buttons/async_button.dart';
import '../../../authentication/presentation/mixin/auth_mixin.dart';

class ProfileScreen extends ConsumerWidget with AuthMixin {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);

    return Scaffold(
      backgroundColor: _colors.surface.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            AsyncButton(
              text: 'Change Theme',
              onClick: () async => ref.read(appThemeProvider.notifier).toggle(),
            ),
            AsyncButton(
              text: 'Sign out',
              onClick: () async => signOut(context: context, ref: ref),
            ),
          ],
        ),
      ),
    );
  }
}
