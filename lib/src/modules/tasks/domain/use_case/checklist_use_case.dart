import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/checklist.dart';
import '../repository/checklist_repository.dart';

class ChecklistUseCase {
  const ChecklistUseCase(this.repository);

  final ChecklistRepository repository;

  AsyncChecklistResult getChecklistsByTaskId(String taskId) =>
      repository.getChecklistsByTaskId(taskId);

  AsyncSingleChecklistResult createChecklist(ChecklistEntity checklist) {
    checklist.validate();
    return repository.createChecklist(checklist);
  }

  AsyncSingleChecklistResult updateChecklist(ChecklistEntity checklist) {
    checklist.validate();
    return repository.updateChecklist(checklist);
  }
}

final checklistUseCaseProvider = Provider.autoDispose<ChecklistUseCase>(
  (ref) => ChecklistUseCase(ref.watch(checklistRepositoryProvider)),
);
