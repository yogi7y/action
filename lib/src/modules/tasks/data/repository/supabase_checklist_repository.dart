import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/checklist.dart';
import '../../domain/repository/checklist_repository.dart';
import '../models/checklist_model.dart';

class SupabaseChecklistRepository with ChecklistModelMixin implements ChecklistRepository {
  const SupabaseChecklistRepository(this.client);

  final SupabaseClient client;

  @override
  AsyncChecklistResult getChecklistsByTaskId(String taskId) async {
    try {
      final response =
          await client.from('checklist_items').select().eq('task_id', taskId).order('created_at');

      final checklists = (response as List<dynamic>)
          .map((item) => fromMapToChecklistEntity(item as Map<String, Object?>? ?? {}))
          .toList();

      return Success(checklists);
    } catch (e, stackTrace) {
      return Failure(AppException(
        exception: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  AsyncSingleChecklistResult deleteChecklist(ChecklistId id) async {
    try {
      final response = await client.from('checklist_items').delete().eq('id', id).select().single();

      return Success(fromMapToChecklistEntity(response));
    } catch (e, stackTrace) {
      return Failure(AppException(
        exception: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  AsyncSingleChecklistResult upsertChecklist(ChecklistEntity checklist) async {
    try {
      final response =
          await client.from('checklist_items').upsert(checklist.toMap()).select().single();

      return Success(fromMapToChecklistEntity(response));
    } catch (e, stackTrace) {
      return Failure(AppException(
        exception: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }
}
