import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/themes/base/theme.dart';
import '../../../../design_system/typography/typography.dart';
import '../../domain/use_case/auth_use_case.dart';

@RoutePage()
class AuthenticationScreen extends ConsumerWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(colorsProvider);
    final _fonts = ref.watch(fontsProvider);

    return Scaffold(
      backgroundColor: _colors.surface.background,
      body: Center(
        child: TextButton(
          onPressed: () async {
            final _authUseCase = ref.read(authUseCaseProvider);

            await _authUseCase.signInWithGoogle();
          },
          child: Text(
            'Sign in with Google',
            style: _fonts.text.lg.semibold,
          ),
        ),
      ),
    );
  }
}
