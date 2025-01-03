import 'package:flutter/foundation.dart';

import '../../domain/entity/checklist.dart';

@immutable
class ChecklistModel extends ChecklistEntity {
  const ChecklistModel({
    required super.id,
    required super.taskId,
    required super.title,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ChecklistModel.fromMap(Map<String, dynamic> map) => ChecklistModel(
        id: map['id'] as String,
        taskId: map['task_id'] as String,
        title: map['title'] as String,
        status: ChecklistStatus.fromString(map['status'] as String),
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );
}
