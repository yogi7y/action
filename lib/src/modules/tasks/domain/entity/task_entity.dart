// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../core/exceptions/validation_exception.dart';
import 'task_status.dart';

@immutable
class TaskEntity implements Comparable<TaskEntity> {
  const TaskEntity({
    required this.name,
    required this.status,
    this.id,
    this.dueDate,
    this.projectId,
    this.contextId,
    this.isOrganized = false,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String name;
  final TaskStatus status;
  final DateTime? dueDate;
  final String? projectId;
  final String? contextId;
  final bool isOrganized;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Logic to determine if the task is organized.
  /// Should only be used for in-memory operations and not to be pushed to the database.
  bool get computedIsOrganized =>
      [TaskStatus.done, TaskStatus.discard].contains(status) ||
      (projectId != null && projectId!.isNotEmpty);

  TaskEntity copyWith({
    String? id,
    String? name,
    TaskStatus? status,
    DateTime? dueDate,
    String? projectId,
    String? contextId,
    bool? isOrganized,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      TaskEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        dueDate: dueDate ?? this.dueDate,
        projectId: projectId ?? this.projectId,
        contextId: contextId ?? this.contextId,
        isOrganized: isOrganized ?? this.isOrganized,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

// todo: write unit tests.
  TaskEntity mark({
    bool dueDateAsNull = false,
    bool projectIdAsNull = false,
    bool contextIdAsNull = false,
    bool idAsNull = false,
  }) =>
      TaskEntity(
        name: name,
        status: status,
        dueDate: dueDateAsNull ? null : dueDate,
        projectId: projectIdAsNull ? null : projectId,
        contextId: contextIdAsNull ? null : contextId,
        id: idAsNull ? null : id,
        isOrganized: isOrganized,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'status': status.value,
        if (dueDate != null) 'due_date': dueDate?.toIso8601String(),
        if (projectId != null) 'project_id': projectId,
        if (contextId != null) 'context_id': contextId,
      };

  void validate() {
    if (name.trim().isEmpty)
      throw ValidationException(
        exception: 'Task name cannot be empty. Got: $name',
        stackTrace: StackTrace.current,
        userFriendlyMessage: 'Task name cannot be empty',
      );
  }

  @override
  String toString() =>
      'TaskEntity(id: $id, name: $name, status: $status, dueDate: $dueDate, projectId: $projectId, contextId: $contextId, isOrganized: $isOrganized, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  bool operator ==(covariant TaskEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.status == status &&
        other.dueDate == dueDate &&
        other.projectId == projectId &&
        other.contextId == contextId &&
        other.isOrganized == isOrganized &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      status.hashCode ^
      dueDate.hashCode ^
      projectId.hashCode ^
      contextId.hashCode ^
      isOrganized.hashCode ^
      createdAt.hashCode;

  @override
  int compareTo(TaskEntity other) {
    final createdAtA = createdAt ?? DateTime.now();
    final createdAtB = other.createdAt ?? DateTime.now();

    return createdAtB.compareTo(createdAtA);
  }
}
