import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/checklist.dart';
import '../state/checklist_provider.dart';
import '../state/task_detail_provider.dart';

mixin ChecklistUiTriggerMixin {
  Future<void> addChecklist({
    required WidgetRef ref,
    required String checklistText,
  }) async {
    final taskId = ref.read(taskDetailNotifierProvider).id;

    if (taskId == null) return;
    await ref
        .read(checklistProvider(taskId).notifier)
        .upsertChecklist(ChecklistEntity.newChecklist(checklistText));
  }
}
