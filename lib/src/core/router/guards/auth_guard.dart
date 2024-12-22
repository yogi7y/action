import 'dart:async';

import 'package:auto_route/auto_route.dart';

import '../../../modules/authentication/domain/use_case/auth_use_case.dart';
import '../app_router.dart';

class AuthGuard extends AutoRouteGuard {
  const AuthGuard({
    required this.authUseCase,
  });

  final AuthUseCase authUseCase;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (authUseCase.isSignedIn) {
      resolver.next();
    } else {
      unawaited(resolver.redirect(const AuthenticationRoute()));
    }
  }
}
