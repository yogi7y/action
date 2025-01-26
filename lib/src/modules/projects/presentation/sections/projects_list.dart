import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/spacing/spacing.dart';
import '../state/projects_provider.dart';
import '../widgets/project_card.dart';

class ProjectGridView extends ConsumerWidget {
  const ProjectGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _size = MediaQuery.of(context).size.width;
    final _spacing = ref.watch(spacingProvider);
    final _cardWidth = (_size - _spacing.lg + _spacing.lg + _spacing.sm) / 2;

    return ref.watch(projectsProvider).when(
          data: (projects) => GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: _spacing.lg),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: _cardWidth,
              crossAxisSpacing: _spacing.sm,
              mainAxisSpacing: _spacing.sm,
              mainAxisExtent: _cardWidth * .7,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) => ProviderScope(
              overrides: [
                scopedProjectProvider.overrideWithValue(projects[index]),
              ],
              child: const ProjectCard(),
            ),
          ),
          error: (error, _) => Center(
            child: Text(error.toString()),
          ),
          loading: SizedBox.shrink,
        );
  }
}
