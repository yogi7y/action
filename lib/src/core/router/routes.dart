import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../modules/area/presentation/screens/area_screen.dart';
import '../../modules/home/presentation/screens/home_screen.dart';
import '../../modules/pages/presentation/screens/pages_screen.dart';
import '../../modules/projects/presentation/screens/projects_screen.dart';
import '../../modules/tasks/domain/entity/task.dart';
import '../../modules/tasks/presentation/screens/task_detail_screen.dart';
import '../../modules/tasks/presentation/screens/tasks_screen.dart';
import '../../modules/tasks/presentation/state/new_task_provider.dart';
import '../logger/logger.dart';

final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

enum AppRoute {
  splash(path: '/splash', name: 'splash'),
  auth(path: '/auth', name: 'auth'),
  home(path: '/home', name: 'home'),
  tasks(path: '/tasks', name: 'tasks'),
  taskDetail(path: '/tasks/:id', name: 'task_detail'),
  pages(path: '/pages', name: 'pages'),
  projects(path: '/projects', name: 'projects'),
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
        onExit: (context, state) {
          logger('home on exit called');
          return false;
        },
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
          onExit: (context, state) {
            final _container = ProviderScope.containerOf(context);
            _container
                .read(isTaskTextInputFieldVisibleProvider.notifier)
                // ignore: avoid_bool_literals_in_conditional_expressions
                .update((state) => state ? false : false);

            return false;
          },
          builder: (context, state) => const TasksScreen(),
          routes: [
            GoRoute(
              name: AppRoute.taskDetail.name,
              path: AppRoute.taskDetail.path,
              builder: (context, state) {
                final _task = state.extra as TaskEntity?;

                return TaskDetailScreen(
                  taskDataOrId: (data: _task, id: null),
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
      ),
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
