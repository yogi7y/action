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
      (iconPath: AssetsV2.home, label: 'Home', path: AppRoute.home.path),
      (iconPath: AssetsV2.addTask, label: 'Tasks', path: AppRoute.tasks.path),
      (iconPath: AssetsV2.bookmarkAdd, label: 'Pages', path: AppRoute.pages.path),
      (iconPath: AssetsV2.hammerOutlined, label: 'Projects', path: AppRoute.projects.path),
      (iconPath: AssetsV2.area, label: 'Area', path: AppRoute.area.path),
    ]);

final selectedBottomNavProvider = StateProvider<SelectedBottomNavItem>(
  (ref) => (index: 0, item: ref.watch(bottomNavItemsProvider).first),
);

final navigatorShellProvider =
    Provider<StatefulNavigationShell>((ref) => throw UnimplementedError());
