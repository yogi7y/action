// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../services/database/model_meta_data.dart';
import '../../../../shared/checkbox/checkbox.dart';

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

  static TaskStatus fromAppCheckboxState(AppCheckboxState state) {
    switch (state) {
      case AppCheckboxState.checked:
        return TaskStatus.done;
      case AppCheckboxState.intermediate:
        return TaskStatus.inProgress;
      case AppCheckboxState.unchecked:
        return TaskStatus.todo;
    }
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

  TaskPropertiesEntity copyWith({
    String? name,
    TaskStatus? status,
    DateTime? dueDate,
    String? projectId,
    String? contextId,
  }) =>
      TaskPropertiesEntity(
        name: name ?? this.name,
        status: status ?? this.status,
        dueDate: dueDate ?? this.dueDate,
        projectId: projectId ?? this.projectId,
        contextId: contextId ?? this.contextId,
      );

  TaskPropertiesEntity mark({
    bool dueDateAsNull = false,
    bool projectIdAsNull = false,
    bool contextIdAsNull = false,
  }) =>
      TaskPropertiesEntity(
        name: name,
        status: status,
        dueDate: dueDateAsNull ? null : dueDate,
        projectId: projectIdAsNull ? null : projectId,
        contextId: contextIdAsNull ? null : contextId,
      );

  Map<String, Object?> toMap() => {
        'name': name,
        'status': status.value,
        if (dueDate != null) 'due_date': dueDate?.millisecondsSinceEpoch,
        if (projectId != null) 'project_id': projectId,
        if (contextId != null) 'context_id': contextId,
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

  TaskEntity copyWith({
    DateTime? createdAt,
    Id? id,
    DateTime? updatedAt,
    String? name,
    TaskStatus? status,
    DateTime? dueDate,
    String? projectId,
    String? contextId,
  }) =>
      TaskEntity(
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        status: status ?? this.status,
        dueDate: dueDate ?? this.dueDate,
        projectId: projectId ?? this.projectId,
        contextId: contextId ?? this.contextId,
      );

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
