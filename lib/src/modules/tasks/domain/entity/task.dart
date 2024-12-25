// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../services/database/model_meta_data.dart';

enum TaskStatus {
  todo('todo'),
  inProgress('in_progress'),
  done('done');

  const TaskStatus(this.value);

  final String value;

  static TaskStatus fromString(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => throw ArgumentError('Invalid task status: $status'),
    );
  }
}

@immutable
class TaskPropertiesEntity {
  const TaskPropertiesEntity({
    required this.name,
    required this.status,
    this.dueDate,
    this.projectId,
    this.contextId,
  });

  final String name;
  final TaskStatus status;
  final DateTime? dueDate;
  final String? projectId;
  final String? contextId;

  Map<String, Object?> toMap() => {
        'name': name,
        'status': status.value,
        if (dueDate != null) 'dueDate': dueDate?.millisecondsSinceEpoch,
        if (projectId != null) 'projectId': projectId,
        if (contextId != null) 'contextId': contextId,
      };

  @override
  String toString() =>
      'TaskPropertiesEntity(name: $name, status: $status, dueDate: $dueDate, projectId: $projectId, contextId: $contextId)';

  @override
  bool operator ==(covariant TaskPropertiesEntity other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.status == status &&
        other.dueDate == dueDate &&
        other.projectId == projectId &&
        other.contextId == contextId;
  }

  @override
  int get hashCode =>
      name.hashCode ^ status.hashCode ^ dueDate.hashCode ^ projectId.hashCode ^ contextId.hashCode;
}

@immutable
class TaskEntity extends TaskPropertiesEntity implements ModelMetaData {
  const TaskEntity({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required super.name,
    required super.status,
    super.contextId,
    super.dueDate,
    super.projectId,
  });

  factory TaskEntity.fromTaskProperties({
    required TaskPropertiesEntity task,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Id id,
  }) =>
      TaskEntity(
        id: id,
        name: task.name,
        status: task.status,
        dueDate: task.dueDate,
        projectId: task.projectId,
        contextId: task.contextId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  @override
  final DateTime createdAt;

  @override
  final Id id;

  @override
  final DateTime updatedAt;

  @override
  String toString() =>
      'TaskEntity(name: $name, status: $status, dueDate: $dueDate, projectId: $projectId, contextId: $contextId, createdAt: $createdAt, id: $id, updatedAt: $updatedAt)';

  @override
  bool operator ==(covariant TaskEntity other) {
    if (identical(this, other)) return true;

    return other.createdAt == createdAt &&
        other.id == id &&
        other.updatedAt == updatedAt &&
        other.name == name &&
        other.status == status &&
        other.dueDate == dueDate &&
        other.projectId == projectId &&
        other.contextId == contextId;
  }

  @override
  int get hashCode =>
      createdAt.hashCode ^
      id.hashCode ^
      updatedAt.hashCode ^
      name.hashCode ^
      status.hashCode ^
      dueDate.hashCode ^
      projectId.hashCode ^
      contextId.hashCode;
}
