import 'package:flutter/foundation.dart';
import '../../../../core/entity.dart';
import '../../../../core/exceptions/validation_exception.dart';
import '../../../../services/database/model_meta_data.dart';
import 'project_status.dart';

@immutable
class ProjectPropertiesEntity implements Entity {
  const ProjectPropertiesEntity({
    required this.name,
    required this.status,
    this.dueDate,
  });

  final String name;
  final ProjectStatus status;
  final DateTime? dueDate;

  ProjectPropertiesEntity copyWith({
    String? name,
    ProjectStatus? status,
    DateTime? dueDate,
  }) =>
      ProjectPropertiesEntity(
        name: name ?? this.name,
        status: status ?? this.status,
        dueDate: dueDate ?? this.dueDate,
      );

  Map<String, Object?> toMap() => {
        'name': name,
        'status': status.value,
        if (dueDate != null) 'due_date': dueDate?.toIso8601String(),
      };

  @override
  bool operator ==(covariant ProjectPropertiesEntity other) {
    if (identical(this, other)) return true;

    return other.name == name && other.status == status && other.dueDate == dueDate;
  }

  @override
  int get hashCode => name.hashCode ^ status.hashCode ^ dueDate.hashCode;

  @override
  String toString() => 'ProjectPropertiesEntity(name: $name, status: $status, dueDate: $dueDate)';

  @override
  void validate() {
    if (name.trim().isEmpty) {
      throw ValidationException(
        exception: 'Project name cannot be empty. Got: $name',
        stackTrace: StackTrace.current,
        userFriendlyMessage: 'Project name cannot be empty',
      );
    }
  }
}

@immutable
class ProjectEntity extends ProjectPropertiesEntity implements ModelMetaData, Entity {
  const ProjectEntity({
    required this.id,
    required super.name,
    required super.status,
    required this.createdAt,
    required this.updatedAt,
    super.dueDate,
  });

  factory ProjectEntity.fromProjectProperties({
    required ProjectPropertiesEntity project,
    required Id id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      ProjectEntity(
        id: id,
        name: project.name,
        status: project.status,
        dueDate: project.dueDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  @override
  final Id id;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  @override
  ProjectEntity copyWith({
    Id? id,
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
