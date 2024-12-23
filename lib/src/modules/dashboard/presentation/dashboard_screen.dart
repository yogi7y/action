import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/router/app_router.dart';
import '../../../design_system/spacing/spacing.dart';
import '../../../design_system/typography/typography.dart';
import '../../context/presentation/state/context_provider.dart';
import '../../projects/presentation/state/projects_provider.dart';
import 'state/app_theme.dart';
import 'state/bottom_nav_items_provider.dart';
import 'state/keyboard_visibility_provider.dart';

@RoutePage()
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    ref
      ..read(projectsProvider)
      ..read(contextsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const [
        HomeRoute(),
        TasksRoute(),
        NotesRoute(),
        ProjectsRoute(),
        AreaRoute(),
      ],
      builder: (context, child, pageController) => _DashboardScreenScaffold(
        controller: pageController,
        child: child,
      ),
    );
  }
}

class _DashboardScreenScaffold extends ConsumerStatefulWidget {
  const _DashboardScreenScaffold({
    required this.child,
    required this.controller,
  });

  final Widget child;
  final PageController controller;

  @override
  ConsumerState<_DashboardScreenScaffold> createState() => _DashboardScreenScaffoldState();
}

class _DashboardScreenScaffoldState extends ConsumerState<_DashboardScreenScaffold> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      final _index = widget.controller.page!.round();
      final _items = ref.read(bottomNavItemsProvider);
      final _newSelectedItem = _items[_index];

      final _newSelectedItemWithIndex = (index: _index, item: _newSelectedItem);

      ref.read(selectedBottomNavProvider.notifier).update((e) => _newSelectedItemWithIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _colors = ref.watch(appThemeProvider);
    final _items = ref.watch(bottomNavItemsProvider);
    final _selectedItem = ref.watch(selectedBottomNavProvider);
    final _tabRouter = AutoTabsRouter.of(context);

    return Scaffold(
      backgroundColor: _colors.surface.background,
      body: widget.child,
      bottomNavigationBar: UnconstrainedBox(
        child: Container(
          decoration: BoxDecoration(
            color: _colors.unselectedBottomNavigationItem.background,
            boxShadow: [
              BoxShadow(
                color: _colors.surface.backgroundContrast.withValues(alpha: .2),
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: _items
                .mapIndexed((index, item) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _tabRouter.setActiveIndex(index);
                        },
                        child: BottomNavItem(
                          data: item,
                          isSelected: item == _selectedItem.item,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends ConsumerWidget {
  const BottomNavItem({
    required this.data,
    this.isSelected = false,
    super.key,
  });

  final BottomNavItemData data;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _spacing = ref.watch(spacingProvider);

    final _backgroundColor = isSelected
        ? _colors.selectedBottomNavigationItem.background
        : _colors.unselectedBottomNavigationItem.background;

    final _labelStyle = isSelected
        ? _fonts.text.xs.semibold.copyWith(
            color: _colors.selectedBottomNavigationItem.text,
          )
        : _fonts.text.xs.medium.copyWith(
            color: _colors.unselectedBottomNavigationItem.text,
          );

    return Container(
      decoration: ShapeDecoration(
        color: _backgroundColor,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: isSelected ? 8 : 0, cornerSmoothing: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: _spacing.sm,
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            data.iconPath,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? _colors.selectedBottomNavigationItem.text
                  : _colors.unselectedBottomNavigationItem.text,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: _spacing.xxs),
          Text(
            data.label,
            style: _labelStyle,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
