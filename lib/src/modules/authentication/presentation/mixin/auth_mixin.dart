import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../domain/use_case/auth_use_case.dart';

typedef SignInCallback = Future<UserResult> Function();

mixin AuthMixin {
  Future<void> singIn({
    required BuildContext context,
    required WidgetRef ref,
    required SignInCallback signInCallback,
  }) async {
    final _router = AutoRouter.of(context);

    final _result = await signInCallback();

    if (_result.isFailure) {
      return;
    }

    await _router.replaceAll([
      const HomeRoute(),
    ]);
  }

  Future<void> signOut({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final _authUseCase = ref.read(authUseCaseProvider);
    final _router = AutoRouter.of(context);

    await _authUseCase.signOut();

    await _router.replaceAll([
      const AuthenticationRoute(),
    ]);
  }
}
