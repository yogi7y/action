import 'package:flutter/foundation.dart';

import '../../domain/entity/project.dart';
import '../../domain/entity/project_relation_metadata.dart';

@immutable
class ProjectViewModel {
  const ProjectViewModel({
    required this.project,
    required this.metadata,
  });

  /// Current project related data
  final ProjectEntity project;

  /// Metadata about project relations (tasks, pages, etc.)
  final ProjectRelationMetadata metadata;

  String get completedAndTotalTasks => '$metadata.completedTasks/$metadata.totalTasks';

  ProjectViewModel copyWith({
    ProjectEntity? project,
    ProjectRelationMetadata? metadata,
  }) =>
      ProjectViewModel(
        project: project ?? this.project,
        metadata: metadata ?? this.metadata,
      );

  @override
  String toString() => 'ProjectViewModel(project: $project, metadata: $metadata)';

  @override
  bool operator ==(covariant ProjectViewModel other) {
    if (identical(this, other)) return true;

    return other.project == project && other.metadata == metadata;
  }

  @override
  int get hashCode => project.hashCode ^ metadata.hashCode;
}
