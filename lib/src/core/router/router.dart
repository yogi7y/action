import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../modules/authentication/presentation/screens/authentication_screen.dart';
import '../../modules/authentication/presentation/screens/splash_screen.dart';
import '../../modules/dashboard/presentation/dashboard_screen.dart';
import '../../modules/profile/presentation/screens/profile_screen.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: true,
    // redirect: (context, state) {
    //   final isAuthenticated = authState.value?.isSignedIn ?? false;
    //   final isAuthScreen = state.matchedLocation == AppRoute.auth.path;
    //   final isSplashScreen = state.matchedLocation == AppRoute.splash.path;

    //   if (isSplashScreen) return null;

    //   if (!isAuthenticated) return isAuthScreen ? null : AppRoute.auth.path;

    //   if (isAuthScreen) return AppRoute.home.path;

    //   return null;
    // },
    routes: [
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        builder: (context, state) => const AuthenticationScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        builder: (context, state) => const ProfileScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardScreen(navigationShell: navigationShell);
        },
        branches: shellBranches,
      ),
    ],
  );
});
