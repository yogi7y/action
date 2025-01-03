import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../modules/authentication/presentation/screens/authentication_screen.dart';
import '../../modules/authentication/presentation/screens/splash_screen.dart';
import '../../modules/dashboard/presentation/dashboard_screen.dart';
import '../../modules/profile/presentation/screens/profile_screen.dart';
import '../../shared/bottom_nav/bottom_nav_items_provider.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final _bottomNavItems = ref.read(bottomNavItemsProvider);
  final _selectedBottomNavNotifier = ref.read(selectedBottomNavProvider.notifier);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      _updateBottomNavFromRoute(
        state,
        _bottomNavItems,
        _selectedBottomNavNotifier,
      );

      return null;
    },
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

void _updateBottomNavFromRoute(
  GoRouterState state,
  List<BottomNavItemData> bottomNavItems,
  StateController<SelectedBottomNavItem> bottomNavNotifier,
) {
  if (state.matchedLocation == AppRoute.home.path) {
    bottomNavNotifier.update((state) => (index: 0, item: bottomNavItems[0]));
  } else if (state.matchedLocation == AppRoute.tasks.path) {
    bottomNavNotifier.update((state) => (index: 1, item: bottomNavItems[1]));
  } else if (state.matchedLocation == AppRoute.pages.path) {
    bottomNavNotifier.update((state) => (index: 2, item: bottomNavItems[2]));
  } else if (state.matchedLocation == AppRoute.projects.path) {
    bottomNavNotifier.update((state) => (index: 3, item: bottomNavItems[3]));
  } else if (state.matchedLocation == AppRoute.area.path) {
    bottomNavNotifier.update((state) => (index: 4, item: bottomNavItems[4]));
  }
}
