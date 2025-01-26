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
    final router = ref.read(routerProvider);

    final result = await signInCallback();

    if (result.isFailure) return;

    /// Just for testing. Revert back to home
    router.goNamed(AppRoute.tasks.name);
  }

  Future<void> signOut({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final router = ref.read(routerProvider);
    final authUseCase = ref.read(authUseCaseProvider);

    await authUseCase.signOut();

    router.goNamed(AppRoute.auth.name);
  }
}
