import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/checkbox/checkbox.dart';
import '../../../../shared/header/detail_header.dart';
import '../state/project_detail_provider.dart';

class ProjectDetailTitle extends ConsumerWidget {
  const ProjectDetailTitle({
    required this.controller,
    required this.tabIndex,
    super.key,
  });

  final ScrollController controller;
  final int tabIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectNotifierProvider);

    final showCheckbox = tabIndex == 0;

    return DetailHeader(
      title: project.project.name,
      scrollController: controller,
      leading: showCheckbox ? const _ProjectDetailCheckbox() : null,
    );
  }
}

class _ProjectDetailCheckbox extends StatelessWidget {
  const _ProjectDetailCheckbox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 2),
      child: Consumer(
        builder: (context, ref, child) => AppCheckbox(
          onChanged: (state) async => ref.read(projectNotifierProvider.notifier).updateProject(
                (project) => project.copyWith(status: state.toProjectStatus()),
              ),
          state: ref.watch(projectNotifierProvider.select(
            (value) => value.project.status.toAppCheckboxState(),
          )),
        ),
      ),
    );
  }
}
