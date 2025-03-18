import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/checklist.dart';
import '../repository/checklist_repository.dart';

class ChecklistUseCase {
  const ChecklistUseCase(this.repository);

  final ChecklistRepository repository;

  AsyncChecklistResult getChecklistsByTaskId(String taskId) =>
      repository.getChecklistsByTaskId(taskId);

  AsyncSingleChecklistResult upsertChecklist(ChecklistEntity checklist) =>
      repository.upsertChecklist(checklist);
}

final checklistUseCaseProvider = Provider.autoDispose<ChecklistUseCase>(
  (ref) => ChecklistUseCase(ref.watch(checklistRepositoryProvider)),
);
