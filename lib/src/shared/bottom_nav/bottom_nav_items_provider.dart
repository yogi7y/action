import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/design_system.dart';

typedef BottomNavItemData = ({
  String iconPath,
  String label,
});

typedef SelectedBottomNavItem = ({int index, BottomNavItemData item});

final bottomNavItemsProvider = Provider<List<BottomNavItemData>>((ref) => [
      (iconPath: Assets.home, label: 'Home'),
      (iconPath: Assets.addTask, label: 'Tasks'),
      (iconPath: Assets.bookmarkAdd, label: 'Pages'),
      (iconPath: Assets.hardware, label: 'Projects'),
      (iconPath: Assets.explore, label: 'Area'),
    ]);

final selectedBottomNavProvider = StateProvider<SelectedBottomNavItem>(
  (ref) => (index: 0, item: ref.watch(bottomNavItemsProvider).first),
);

final navigatorShellProvider =
    Provider<StatefulNavigationShell>((ref) => throw UnimplementedError());
