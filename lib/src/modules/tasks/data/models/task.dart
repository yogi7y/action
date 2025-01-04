import 'package:flutter/material.dart';

import '../../domain/entity/task.dart';

@immutable
class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.name,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.dueDate,
    super.projectId,
    super.contextId,
    super.isOrganized,
  });

  factory TaskModel.fromMap(Map<String, Object?> map) {
    return TaskModel(
      id: map['id'] as String,
      name: map['name'] as String,
      status: TaskStatus.fromString(map['status'] as String),
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date'] as String) : null,
      projectId: map['project_id'] as String?,
      contextId: map['context_id'] as String?,
      isOrganized: map['is_organized'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
