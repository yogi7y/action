import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/project_detail_provider.dart';
import '../view_models/project_view_model.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  const ProjectDetailScreen({
    required this.projectOrId,
    super.key,
  });

  final ProjectOrId projectOrId;

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  late final ScrollController scrollController = ScrollController();

  late final _tasksSectionKey = GlobalKey(debugLabel: 'Checklist Section');
  late final _pagesSectionKey = GlobalKey(debugLabel: 'Checklist Section');

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _project = ref.watch(projectDetailProvider(widget.projectOrId));

    return ProviderScope(
      child: Scaffold(
        body: switch (_project) {
          AsyncData(value: final project) => ProviderScope(
              overrides: [
                scopedProjectProvider.overrideWith(
                  () => ProjectNotifier(
                    ProjectViewModel(
                      project: project,
                      totalTasks: 0,
                      totalPages: 0,
                    ),
                  ),
                ),
              ],
              child: const CustomScrollView(),
            ),
          AsyncError(error: final error) => Center(child: Text(error.toString())),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}
