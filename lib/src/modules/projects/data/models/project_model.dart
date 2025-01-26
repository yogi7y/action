import 'package:flutter/material.dart';

import '../../../../core/validators/serialization_validators.dart';
import '../../domain/entity/project.dart';
import '../../domain/entity/project_status.dart';

@immutable
class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.dueDate,
  });

  factory ProjectModel.fromMap(Map<String, Object?> map) {
    final validator = FieldTypeValidator(map, StackTrace.current);

    final id = validator.isOfType<String>('id');
    final name = validator.isOfType<String>('name');
    final statusStr = validator.isOfType<String>('status');
    final createdAt = validator.isOfType<String>('created_at');
    final updatedAt = validator.isOfType<String>('updated_at');

    return ProjectModel(
      id: id,
      name: name,
      status: ProjectStatus.fromString(statusStr),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
