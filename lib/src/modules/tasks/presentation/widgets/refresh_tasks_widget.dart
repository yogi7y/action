import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshTasksWidget extends ConsumerWidget {
  const RefreshTasksWidget({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return child;
    // final moduleData = ref.watch(taskModelDataProvider);

    // return RefreshIndicator(
    //   onRefresh: () async {
    //     final taskView = ref.read(scopedTaskViewProvider);

    //     ref.invalidate(tasksProvider(taskView));

    //     await Future.wait([
    //       ref.read(tasksProvider(taskView).future),
    //       if (moduleData.onRefresh != null) moduleData.onRefresh!(),
    //     ]);
    //   },
    //   child: child,
    // );
  }
}
