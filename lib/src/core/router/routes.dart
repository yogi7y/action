import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modules/area/presentation/screens/area_screen.dart';
import '../../modules/home/presentation/screens/home_screen.dart';
import '../../modules/pages/presentation/screens/pages_screen.dart';
import '../../modules/projects/domain/entity/project.dart';
import '../../modules/projects/presentation/screens/project_detail_screen.dart';
import '../../modules/projects/presentation/screens/projects_screen.dart';
import '../../modules/tasks/presentation/screens/task_detail_screen.dart';
import '../../modules/tasks/presentation/screens/tasks_screen.dart';
import '../../modules/tasks/presentation/state/task_detail_provider.dart';
import '../exceptions/route_exception.dart';

final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

typedef TaskDetailRouteData = ({TaskDataOrId? value, int? index});

enum AppRoute {
  splash(path: '/splash', name: 'splash'),
  auth(path: '/auth', name: 'auth'),
  home(path: '/home', name: 'home'),
  tasks(path: '/tasks', name: 'tasks'),
  taskDetail(path: '/tasks/:id', name: 'task_detail'),
  pages(path: '/pages', name: 'pages'),
  projects(path: '/projects', name: 'projects'),
  projectDetail(path: '/projects/:id', name: 'project_detail'),
  area(path: '/area', name: 'area'),
  profile(path: '/profile', name: 'profile');

  const AppRoute({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}

// Shell branch navigation keys
final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final tasksNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'tasks');
final pagesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'pages');
final projectsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'projects');
final areaNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'area');

final shellBranches = [
  StatefulShellBranch(
    navigatorKey: homeNavigatorKey,
    routes: [
      GoRoute(
        name: AppRoute.home.name,
        path: AppRoute.home.path,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: tasksNavigatorKey,
    routes: [
      GoRoute(
          name: AppRoute.tasks.name,
          path: AppRoute.tasks.path,
          builder: (context, state) => const TasksScreen(),
          routes: [
            GoRoute(
              name: AppRoute.taskDetail.name,
              path: AppRoute.taskDetail.path,
              builder: (context, state) {
                final _task = state.extra as TaskDetailRouteData?;

                if (_task == null) throw Exception('TaskDetailRouteData is required');

                return TaskDetailScreen(
                  taskDataOrId: _task.value!,
                  index: _task.index,
                );
              },
            ),
          ]),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: pagesNavigatorKey,
    routes: [
      GoRoute(
        name: AppRoute.pages.name,
        path: AppRoute.pages.path,
        builder: (context, state) => const PagesScreen(),
      ),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: projectsNavigatorKey,
    routes: [
      GoRoute(
          name: AppRoute.projects.name,
          path: AppRoute.projects.path,
          builder: (context, state) => const ProjectsScreen(),
          routes: [
            GoRoute(
              name: AppRoute.projectDetail.name,
              path: ':id',
              builder: handleProjectDetailScreenRoute,
            ),
          ]),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: areaNavigatorKey,
    routes: [
      GoRoute(
        name: AppRoute.area.name,
        path: AppRoute.area.path,
        builder: (context, state) => const AreaScreen(),
      ),
    ],
  ),
];

typedef RouteDetails = (BuildContext context, GoRouterState state);

@visibleForTesting
Widget handleProjectDetailScreenRoute(BuildContext context, GoRouterState state) {
  if (state.extra is! ProjectEntity?)
    throw RouteException(
      exception: 'Data must be of type ProjectEntity or null',
      stackTrace: StackTrace.current,
      route: state.fullPath ?? state.path ?? '',
      uri: state.uri,
      details: {
        'projectData': state.extra,
        'type': state.extra.runtimeType,
      },
    );

  final projectData = state.extra as ProjectEntity?;
  final id = state.pathParameters['id'];

  if (projectData == null && id == null)
    throw RouteException(
      exception: 'Either project data or ID is required',
      stackTrace: StackTrace.current,
      route: state.fullPath ?? state.path ?? '',
      uri: state.uri,
      details: {
        'projectData': projectData,
        'id': id,
      },
    );

  final projectOrId = (
    id: id,
    value: projectData,
  );

  return ProjectDetailScreen(projectOrId: projectOrId);
}
