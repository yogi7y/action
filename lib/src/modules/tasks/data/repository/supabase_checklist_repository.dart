import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/checklist.dart';
import '../../domain/repository/checklist_repository.dart';
import '../models/checklist_model.dart';

class SupabaseChecklistRepository implements ChecklistRepository {
  const SupabaseChecklistRepository(this.client);

  final SupabaseClient client;

  @override
  AsyncChecklistResult getChecklistsByTaskId(String taskId) async {
    try {
      final response =
          await client.from('checklist_items').select().eq('task_id', taskId).order('created_at');

      final checklists = (response as List<dynamic>)
          .map((item) => ChecklistModel.fromMap(item as Map<String, Object?>? ?? {}))
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
  AsyncSingleChecklistResult createChecklist(ChecklistPropertiesEntity checklist) async {
    try {
      final response =
          await client.from('checklist_items').insert(checklist.toMap()).select().single();

      return Success(ChecklistModel.fromMap(response));
    } catch (e, stackTrace) {
      return Failure(AppException(
        exception: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  AsyncSingleChecklistResult deleteChecklist(ChecklistId id) {
    throw UnimplementedError();
  }

  @override
  AsyncSingleChecklistResult updateChecklist(ChecklistEntity checklist) async {
    try {
      final _id = checklist.id;
      final _data = checklist.toMap();

      final _response = await client
          .from('checklist_items') //
          .update(_data)
          .eq('id', _id)
          .select()
          .single();

      final _result = ChecklistModel.fromMap(_response);
      return Success(_result);
    } catch (e, stackTrace) {
      return Failure(AppException(
        exception: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }
}
