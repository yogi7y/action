import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../design_system/icons/app_icons.dart';

typedef BottomNavItemData = ({
  IconData icon,
  String label,
  String path,
});

typedef SelectedBottomNavItem = ({
  int index,
  BottomNavItemData item,
});

final bottomNavItemsProvider = Provider<List<BottomNavItemData>>((ref) => [
      (icon: AppIcons.houseSmile, label: 'Home', path: AppRoute.home.path),
      (icon: AppIcons.addTaskOutlined, label: 'Tasks', path: AppRoute.tasks.path),
      (icon: AppIcons.bookmarkAddOutlined, label: 'Pages', path: AppRoute.pages.path),
      (icon: AppIcons.hammerOutlined, label: 'Projects', path: AppRoute.projects.path),
      (icon: AppIcons.area, label: 'Area', path: AppRoute.area.path),
    ]);

final selectedBottomNavProvider = StateProvider<SelectedBottomNavItem>(
  (ref) => (index: 0, item: ref.watch(bottomNavItemsProvider).first),
);

final navigatorShellProvider =
    Provider<StatefulNavigationShell>((ref) => throw UnimplementedError());
