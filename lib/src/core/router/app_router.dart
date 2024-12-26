import 'package:auto_route/auto_route.dart';

import '../../modules/area/presentation/screens/area_screen.dart';
import '../../modules/authentication/presentation/screens/authentication_screen.dart';
import '../../modules/authentication/presentation/screens/splash_screen.dart';
import '../../modules/dashboard/presentation/dashboard_screen.dart';
import '../../modules/home/presentation/screens/home_screen.dart';
import '../../modules/pages/presentation/screens/pages_screen.dart';
import '../../modules/profile/presentation/screens/profile_screen.dart';
import '../../modules/projects/presentation/screens/projects_screen.dart';
import '../../modules/tasks/presentation/screens/tasks_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: AuthenticationRoute.page,
          path: '/auth',
        ),
        AutoRoute(
          page: ProfileRoute.page,
          path: '/profile',
        ),
        AutoRoute(
          page: DashboardRoute.page,
          path: '/dashboard',
          children: [
            AutoRoute(path: 'home', page: HomeRoute.page),
            AutoRoute(path: 'tasks', page: TasksRoute.page),
            AutoRoute(path: 'pages', page: NotesRoute.page),
            AutoRoute(path: 'projects', page: ProjectsRoute.page),
            AutoRoute(path: 'area', page: AreaRoute.page),
          ],
        ),
      ];
}
