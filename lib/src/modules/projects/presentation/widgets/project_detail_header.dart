import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/checkbox/checkbox.dart';
import '../../../../shared/header/detail_header.dart';
import '../../domain/entity/project_status.dart';
import '../state/project_detail_provider.dart';

class ProjectDetailHeader extends ConsumerWidget {
  const ProjectDetailHeader({
    required this.controller,
    super.key,
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectNotifierProvider);

    return DetailHeader(
      title: project.project.name,
      scrollController: controller,
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
          onChanged: (state) async {},
          state: AppCheckboxState.checked,
        ),
      ),
    );
  }
}
