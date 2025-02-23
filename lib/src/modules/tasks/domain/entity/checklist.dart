// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../../../../core/exceptions/validation_exception.dart';
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
class ChecklistEntity {
  const ChecklistEntity({
    required this.taskId,
    required this.title,
    required this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final TaskId taskId;
  final String title;
  final ChecklistStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChecklistEntity copyWith({
    String? id,
    TaskId? taskId,
    String? title,
    ChecklistStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ChecklistEntity(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'task_id': taskId,
        'title': title,
        'status': status.value,
      };

  @override
  String toString() =>
      'ChecklistEntity(id: $id, taskId: $taskId, title: $title, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  bool operator ==(covariant ChecklistEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.taskId == taskId &&
        other.title == title &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      taskId.hashCode ^
      title.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  void validate() {
    if (title.isEmpty) {
      throw ValidationException(
        exception: 'Checklist title cannot be empty. Got: $title',
        stackTrace: StackTrace.current,
        userFriendlyMessage: 'Checklist title cannot be empty',
      );
    }
  }
}
