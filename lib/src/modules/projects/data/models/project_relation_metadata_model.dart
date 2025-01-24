import 'package:flutter/foundation.dart';

import '../../../../core/validators/serialization_validators.dart';
import '../../domain/entity/project_relation_metadata.dart';

@immutable
class ProjectRelationMetadataModel extends ProjectRelationMetadata {
  const ProjectRelationMetadataModel({
    required super.projectId,
    required super.totalTasks,
    required super.completedTasks,
    required super.totalPages,
  });

  factory ProjectRelationMetadataModel.fromMap(Map<String, Object?> map) {
    final validator = FieldTypeValidator(map, StackTrace.current);

    final projectId = validator.isOfType<String>('project_id');
    final totalTasks = validator.isOfType<int>('total_tasks');
    final completedTasks = validator.isOfType<int>('completed_tasks');
    final totalPages = validator.isOfType<int>('total_pages');

    return ProjectRelationMetadataModel(
      projectId: projectId,
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      totalPages: totalPages,
    );
  }
}
