import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/checkbox/checkbox.dart';
import '../../../../shared/header/detail_header.dart';
import '../../domain/entity/task_status.dart';
import '../state/task_detail_provider.dart';

class TaskDetailHeader extends ConsumerWidget {
  const TaskDetailHeader({
    required this.title,
    required this.scrollController,
    super.key,
  });

  final String title;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DetailHeader(
      data: DetailHeaderData(
        title: title,
        scrollController: scrollController,
        leading: const _Checkbox(),
        onTextChanged: (value) async => ref.read(taskDetailNotifierProvider.notifier).updateTask(
              (task) => task.copyWith(name: value),
            ),
      ),
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
            await ref.read(taskDetailNotifierProvider.notifier).updateTask(
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
