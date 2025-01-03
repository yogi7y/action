import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/router.dart';
import '../../../../core/router/routes.dart';
import '../../domain/use_case/auth_use_case.dart';

typedef SignInCallback = Future<UserResult> Function();

mixin AuthMixin {
  Future<void> singIn({
    required BuildContext context,
    required WidgetRef ref,
    required SignInCallback signInCallback,
  }) async {
    final _router = ref.read(routerProvider);

    final _result = await signInCallback();

    if (_result.isFailure) return;

    /// Just for testing. Revert back to home
    _router.goNamed(AppRoute.tasks.name);
  }

  Future<void> signOut({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final _router = ref.read(routerProvider);
    final _authUseCase = ref.read(authUseCaseProvider);

    await _authUseCase.signOut();

    _router.goNamed(AppRoute.auth.name);
  }
}
