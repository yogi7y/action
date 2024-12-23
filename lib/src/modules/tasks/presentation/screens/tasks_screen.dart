import 'package:auto_route/auto_route.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_textfield/smart_textfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/assets.dart';
import '../../../../design_system/spacing/spacing.dart';
import '../../../../design_system/typography/typography.dart';
import '../../../../shared/chips/chips.dart';
import '../../../dashboard/presentation/state/app_theme.dart';
import '../sections/task_input_field.dart';
import '../sections/tasks_filters.dart';
import '../sections/tasks_list.dart';
import '../state/new_task_provider.dart';
import '../state/tasks_provider.dart';

@RoutePage()
class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _fonts = ref.watch(fontsProvider);
    final _colors = ref.watch(appThemeProvider);
    final _spacing = ref.watch(spacingProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leadingWidth: 0,
            pinned: true,
            elevation: 0,
            titleSpacing: _spacing.lg,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: false,
            toolbarHeight: kToolbarHeight + _spacing.md,
            backgroundColor: _colors.surface.background,
            title: Text(
              'Tasks',
              style: _fonts.headline.lg.semibold,
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  Assets.search,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(_colors.textTokens.primary, BlendMode.srcIn),
                ),
              ),
              SizedBox(width: _spacing.xs),
            ],
          ),
          SliverToBoxAdapter(child: SizedBox(height: _spacing.xxs)),
          const SliverToBoxAdapter(child: TasksFilters()),
          SliverToBoxAdapter(child: SizedBox(height: _spacing.lg)),
          const SliverToBoxAdapter(child: TaskInputFieldVisibility()),
          const SliverTasksList(),
          SliverToBoxAdapter(child: SizedBox(height: _spacing.xxl)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(isTaskTextInputFieldVisibleProvider.notifier).update((value) => !value);
        },
        backgroundColor: _colors.primary,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
        ),
        child: SvgPicture.asset(
          Assets.add,
          height: 32,
          width: 32,
        ),
      ),
    );
  }
}
