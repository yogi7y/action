import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/assets.dart';
import '../../../../design_system/spacing/spacing.dart';
import '../../../../design_system/typography/typography.dart';
import '../../../../shared/chips/chips.dart';
import '../../../dashboard/presentation/state/app_theme.dart';
import '../sections/tasks_filters.dart';
import '../sections/tasks_list.dart';
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
      appBar: AppBar(
        backgroundColor: _colors.surface.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(left: _spacing.md),
          child: Text(
            'Tasks',
            style: _fonts.headline.lg.semibold,
          ),
        ),
        actions: [
          SvgPicture.asset(
            Assets.search,
            height: 24,
            width: 24,
          ),
          SizedBox(width: _spacing.lg),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: _spacing.md),
          const TasksFilters(),
          SizedBox(height: _spacing.xxl),
          const Expanded(child: TasksList()),
        ],
      ),
    );
  }
}
