import 'package:flutter/material.dart';

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
class TaskEntity {
  const TaskEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.projectId,
    this.contextId,
  });

  final String id;
  final String name;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final String? projectId;
  final String? contextId;

  TaskEntity copyWith({
    String? id,
    String? name,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    String? projectId,
    String? contextId,
  }) =>
      TaskEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        dueDate: dueDate ?? this.dueDate,
        projectId: projectId ?? this.projectId,
        contextId: contextId ?? this.contextId,
      );

  @override
  String toString() =>
      'TaskEntity(id: $id, name: $name, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, dueDate: $dueDate, projectId: $projectId, contextId: $contextId)';

  @override
  bool operator ==(covariant TaskEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.dueDate == dueDate &&
        other.projectId == projectId &&
        other.contextId == contextId;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      dueDate.hashCode ^
      projectId.hashCode ^
      contextId.hashCode;
}
