import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/checklist_provider.dart';
import '../state/task_detail_provider.dart';

mixin ChecklistUiTriggerMixin {
  Future<void> addChecklist({
    required WidgetRef ref,
    required String checklistText,
  }) async {
    final taskId = ref.read(taskDetailNotifierProvider).id;
    // await ref.read(checklistProvider(taskId!).notifier).updateChecklist(checklistText);
  }
}
