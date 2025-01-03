import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../design_system/design_system.dart';

typedef BottomNavItemData = ({
  String iconPath,
  String label,
  String path,
});

typedef SelectedBottomNavItem = ({
  int index,
  BottomNavItemData item,
});

final bottomNavItemsProvider = Provider<List<BottomNavItemData>>((ref) => [
      (iconPath: Assets.home, label: 'Home', path: AppRoute.home.path),
      (iconPath: Assets.addTask, label: 'Tasks', path: AppRoute.tasks.path),
      (iconPath: Assets.bookmarkAdd, label: 'Pages', path: AppRoute.pages.path),
      (iconPath: AssetsV2.hammerOutlined, label: 'Projects', path: AppRoute.projects.path),
      (iconPath: Assets.explore, label: 'Area', path: AppRoute.area.path),
    ]);

final selectedBottomNavProvider = StateProvider<SelectedBottomNavItem>(
  (ref) => (index: 0, item: ref.watch(bottomNavItemsProvider).first),
);

final navigatorShellProvider =
    Provider<StatefulNavigationShell>((ref) => throw UnimplementedError());
