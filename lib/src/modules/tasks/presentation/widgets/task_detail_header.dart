import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/checkbox/checkbox.dart';
import '../../../../shared/header/detail_header.dart';
import '../../domain/entity/task.dart';
import '../state/task_detail_provider.dart';

class TaskDetailHeader extends StatelessWidget {
  const TaskDetailHeader({
    required this.title,
    required this.scrollController,
    super.key,
  });

  final String title;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return DetailHeader(
      title: title,
      scrollController: scrollController,
      leading: const _Checkbox(),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 2),
      child: Consumer(
        builder: (context, ref, child) => AppCheckbox(
          onChanged: (state) async {
            await ref.read(taskDetailNotifierProvider.notifier).updateTaskWithCallback(
                  (task) => task.copyWith(status: TaskStatus.fromAppCheckboxState(state)),
                );
          },
          state: AppCheckboxState.fromTaskStatus(
            status: ref.watch(
              taskDetailNotifierProvider.select((value) => value.status),
            ),
          ),
        ),
      ),
    );
  }
}
