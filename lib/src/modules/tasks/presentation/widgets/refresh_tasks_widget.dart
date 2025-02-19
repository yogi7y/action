import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/scoped_task_provider.dart';
import '../state/tasks_provider.dart';

class RefreshTasksWidget extends ConsumerWidget {
  const RefreshTasksWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        final taskView = ref.read(scopedTaskViewProvider);
        ref.invalidate(tasksNotifierProvider(taskView));
        await ref.read(tasksNotifierProvider(taskView).future);
      },
      child: child,
    );
  }
}
