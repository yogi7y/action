import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/header/detail_header.dart';
import '../state/project_detail_provider.dart';
import '../view_models/project_view_model.dart';
import '../widgets/project_detail_header.dart';

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
                projectNotifierProvider.overrideWith(
                  () => ProjectNotifier(
                    ProjectViewModel(project: project, totalTasks: 0, totalPages: 0),
                  ),
                ),
              ],
              child: _ProjectDetailDataState(controller: scrollController),
            ),
          AsyncError(error: final error) => Center(child: Text(error.toString())),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

@immutable
class _ProjectDetailDataState extends ConsumerWidget {
  const _ProjectDetailDataState({
    required this.controller,
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectNotifierProvider);
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);

    return Scaffold(
      backgroundColor: colors.surface.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 1000));
        },
        child: CustomScrollView(
          slivers: [ProjectDetailHeader(controller: controller)],
        ),
      ),
    );
  }
}
