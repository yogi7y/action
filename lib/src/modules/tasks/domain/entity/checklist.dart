// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../../../../services/database/model_meta_data.dart';
import '../use_case/task_use_case.dart';

enum ChecklistStatus {
  todo('todo'),
  done('done');

  const ChecklistStatus(this.value);
  final String value;

  static ChecklistStatus fromString(String status) {
    return ChecklistStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => throw ArgumentError('Invalid checklist status: $status'),
    );
  }
}

@immutable
class ChecklistPropertiesEntity {
  const ChecklistPropertiesEntity({
    required this.taskId,
    required this.title,
    required this.status,
  });

  final TaskId taskId;
  final String title;
  final ChecklistStatus status;

  ChecklistPropertiesEntity copyWith({
    String? taskId,
    String? title,
    ChecklistStatus? status,
  }) =>
      ChecklistPropertiesEntity(
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        status: status ?? this.status,
      );

  Map<String, Object?> toMap() => {
        'task_id': taskId,
        'title': title,
        'status': status.value,
      };

  @override
  bool operator ==(covariant ChecklistPropertiesEntity other) {
    if (identical(this, other)) return true;

    return other.taskId == taskId && other.title == title && other.status == status;
  }

  @override
  int get hashCode => taskId.hashCode ^ title.hashCode ^ status.hashCode;

  @override
  String toString() => 'ChecklistPropertiesEntity(taskId: $taskId, title: $title, status: $status)';
}

@immutable
class ChecklistEntity extends ChecklistPropertiesEntity implements ModelMetaData {
  const ChecklistEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required super.taskId,
    required super.title,
    required super.status,
  });

  factory ChecklistEntity.fromChecklistProperties({
    required ChecklistPropertiesEntity checklist,
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      ChecklistEntity(
        id: id,
        taskId: checklist.taskId,
        title: checklist.title,
        status: checklist.status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  ChecklistEntity copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    TaskId? taskId,
    String? title,
    ChecklistStatus? status,
  }) =>
      ChecklistEntity(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        status: status ?? this.status,
      );

  @override
  bool operator ==(covariant ChecklistEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.taskId == taskId &&
        other.title == title &&
        other.status == status;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      taskId.hashCode ^
      title.hashCode ^
      status.hashCode;

  @override
  String toString() =>
      'ChecklistEntity(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, taskId: $taskId, title: $title, status: $status)';
}
