// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../../../../core/exceptions/validation_exception.dart';
import 'project_status.dart';

@immutable
class ProjectEntity {
  const ProjectEntity({
    required this.name,
    required this.status,
    this.id,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String name;
  final ProjectStatus status;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'status': status.value,
        if (dueDate != null) 'due_date': dueDate?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),

        /// check: do we need to remove these field from toMap?
        'updated_at': updatedAt?.toIso8601String(),
      };

  void validate() {
    if (name.trim().isEmpty) {
      throw ValidationException(
        exception: 'Project name cannot be empty. Got: $name',
        stackTrace: StackTrace.current,
        userFriendlyMessage: 'Project name cannot be empty',
      );
    }
  }

  ProjectEntity copyWith({
    String? id,
    String? name,
    ProjectStatus? status,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ProjectEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        dueDate: dueDate ?? this.dueDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  String toString() =>
      'ProjectEntity(id: $id, name: $name, status: $status, dueDate: $dueDate, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  bool operator ==(covariant ProjectEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.status == status &&
        other.dueDate == dueDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      status.hashCode ^
      dueDate.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
