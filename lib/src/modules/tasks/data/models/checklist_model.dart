import '../../../../core/validators/serialization_validators.dart';
import '../../domain/entity/checklist.dart';

mixin ChecklistModelMixin {
  ChecklistEntity fromMapToChecklistEntity(Map<String, Object?> map) {
    final validator = FieldTypeValidator(map, StackTrace.current);

    final id = validator.isOfType<String>('id');
    final taskId = validator.isOfType<String>('task_id');
    final title = validator.isOfType<String>('title');
    final statusStr = validator.isOfType<String>('status');
    final createdAt = validator.isOfType<String>('created_at');
    final updatedAt = validator.isOfType<String>('updated_at');

    return ChecklistEntity(
      id: id,
      taskId: taskId,
      title: title,
      status: ChecklistStatus.fromString(statusStr),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
