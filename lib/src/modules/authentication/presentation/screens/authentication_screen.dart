import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../domain/use_case/auth_use_case.dart';
import '../mixin/auth_mixin.dart';

class AuthenticationScreen extends ConsumerWidget with AuthMixin {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    return Scaffold(
      backgroundColor: _colors.surface.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            TextButton(
              onPressed: () async {
                final _authUseCase = ref.read(authUseCaseProvider);

                await singIn(
                  context: context,
                  ref: ref,
                  signInCallback: _authUseCase.signInWithGoogle,
                );
              },
              child: Text(
                'Sign in with Google',
                style: _fonts.text.lg.semibold,
              ),
            ),
            TextButton(
              onPressed: () async {
                final _authUseCase = ref.read(authUseCaseProvider);

                await singIn(
                  context: context,
                  ref: ref,
                  signInCallback: () {
                    return _authUseCase.signInWithEmailAndPassword(
                      email: 'yogeshparwani99.yp@gmail.com',
                      password: 'localtest',
                    );
                  },
                );
              },
              child: Text(
                'Sign in with Password',
                style: _fonts.text.lg.semibold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
