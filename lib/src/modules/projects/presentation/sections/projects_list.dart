import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/spacing/spacing.dart';
import '../state/projects_provider.dart';
import '../widgets/project_card.dart';

class ProjectGridView extends ConsumerWidget {
  const ProjectGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size.width;
    final spacing = ref.watch(spacingProvider);
    final cardWidth = (size - spacing.lg + spacing.lg + spacing.sm) / 2;

    return ref.watch(projectsProvider).when(
          data: (projects) => RefreshIndicator(
            onRefresh: () async => ref.refresh(projectsProvider),
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: cardWidth,
                crossAxisSpacing: spacing.sm,
                mainAxisSpacing: spacing.sm,
                mainAxisExtent: cardWidth * .7,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) => ProviderScope(
                overrides: [
                  scopedProjectProvider.overrideWithValue(projects[index]),
                ],
                child: const ProjectCard(),
              ),
            ),
          ),
          error: (error, _) => Center(
            child: Text(error.toString()),
          ),
          loading: SizedBox.shrink,
        );
  }
}
