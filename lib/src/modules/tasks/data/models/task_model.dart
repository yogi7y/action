import 'package:flutter/material.dart';

import '../../../../core/validators/serialization_validators.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/entity/task_status.dart';

// @immutable
// class TaskModel extends TaskEntity {
//   const TaskModel({
//     required super.id,
//     required super.name,
//     required super.status,
//     required super.createdAt,
//     required super.updatedAt,
//     super.dueDate,
//     super.projectId,
//     super.contextId,
//     super.isOrganized,
//   });

//   factory TaskModel.fromMap(Map<String, Object?> map) {
//     final validator = FieldTypeValidator(map, StackTrace.current);

//     final id = validator.isOfType<String>('id');
//     final name = validator.isOfType<String>('name');
//     final statusStr = validator.isOfType<String>('status');
//     final isOrganized = validator.isOfType<bool>('is_organized', fallback: false);
//     final createdAt = validator.isOfType<String>('created_at');
//     final updatedAt = validator.isOfType<String>('updated_at');

//     final dueDateStr = validator.isOfType<String?>('due_date');
//     final projectId = validator.isOfType<String?>('project_id');
//     final contextId = validator.isOfType<String?>('context_id');

//     return TaskModel(
//       id: id,
//       name: name,
//       status: TaskStatus.fromString(statusStr),
//       createdAt: DateTime.parse(createdAt),
//       updatedAt: DateTime.parse(updatedAt),
//       dueDate: dueDateStr != null ? DateTime.parse(dueDateStr) : null,
//       projectId: projectId,
//       contextId: contextId,
//       isOrganized: isOrganized,
//     );
//   }
// }

mixin TaskModelMixin {
  TaskEntity fromMapToTaskEntity(Map<String, Object?> map) {
    final validator = FieldTypeValidator(map, StackTrace.current);

    final id = validator.isOfType<String>('id');
    final name = validator.isOfType<String>('name');
    final statusStr = validator.isOfType<String>('status');
    final isOrganized = validator.isOfType<bool>('is_organized', fallback: false);
    final createdAt = validator.isOfType<String>('created_at');
    final updatedAt = validator.isOfType<String>('updated_at');

    final dueDateStr = validator.isOfType<String?>('due_date');
    final projectId = validator.isOfType<String?>('project_id');
    final contextId = validator.isOfType<String?>('context_id');

    return TaskEntity(
      id: id,
      name: name,
      status: TaskStatus.fromString(statusStr),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      dueDate: dueDateStr != null ? DateTime.parse(dueDateStr) : null,
      projectId: projectId,
      contextId: contextId,
      isOrganized: isOrganized,
    );
  }
}
