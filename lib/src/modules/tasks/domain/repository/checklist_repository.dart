import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/database/supabase_provider.dart';
import '../../data/repository/supabase_checklist_repository.dart';
import '../entity/checklist.dart';
import '../use_case/task_use_case.dart';

typedef ChecklistId = String;
typedef ChecklistResult = Result<List<ChecklistEntity>, AppException>;
typedef AsyncChecklistResult = Future<ChecklistResult>;
typedef SingleChecklistResult = Result<ChecklistEntity, AppException>;
typedef AsyncSingleChecklistResult = Future<SingleChecklistResult>;

abstract class ChecklistRepository {
  AsyncChecklistResult getChecklistsByTaskId(TaskId taskId);
  AsyncSingleChecklistResult upsertChecklist(ChecklistEntity checklist);

  AsyncSingleChecklistResult deleteChecklist(ChecklistId id);
}

final checklistRepositoryProvider = Provider.autoDispose<ChecklistRepository>(
  (ref) => SupabaseChecklistRepository(ref.watch(supabaseClientProvider)),
);
