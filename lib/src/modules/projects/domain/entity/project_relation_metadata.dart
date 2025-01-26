import 'package:flutter/foundation.dart';

import '../repository/project_repository.dart';

/// Represents metadata about a project's relationships with other entities like tasks and pages.
@immutable
class ProjectRelationMetadata {
  /// Creates a new [ProjectRelationMetadata] instance
  ///
  /// [totalTasks] represents the total number of tasks in the project
  /// [completedTasks] represents the number of completed tasks
  /// [totalPages] represents the total number of pages in the project
  /// [projectId] represents the id of the project for which the metadata is being fetched
  const ProjectRelationMetadata({
    required this.projectId,
    required this.totalTasks,
    required this.completedTasks,
    required this.totalPages,
  });

  /// The id of the project for which the metadata is being fetched
  final ProjectId projectId;

  /// The total number of tasks in the project
  final int totalTasks;

  /// The number of completed tasks in the project
  final int completedTasks;

  /// The total number of pages in the project
  final int totalPages;

  /// The percentage of tasks that are completed, from 0 to 100
  /// Returns 0 if there are no tasks
  double get completionPercentage => totalTasks == 0 ? 0 : (completedTasks / totalTasks) * 100;

  ProjectRelationMetadata copyWith({
    int? totalTasks,
    int? completedTasks,
    int? totalPages,
    ProjectId? projectId,
  }) =>
      ProjectRelationMetadata(
        projectId: projectId ?? this.projectId,
        totalTasks: totalTasks ?? this.totalTasks,
        completedTasks: completedTasks ?? this.completedTasks,
        totalPages: totalPages ?? this.totalPages,
      );

  @override
  String toString() =>
      'ProjectRelationMetadata(projectId: $projectId, totalTasks: $totalTasks, completedTasks: $completedTasks, totalPages: $totalPages)';

  @override
  bool operator ==(covariant ProjectRelationMetadata other) {
    if (identical(this, other)) return true;

    return other.totalTasks == totalTasks &&
        other.completedTasks == completedTasks &&
        other.totalPages == totalPages &&
        other.projectId == projectId;
  }

  @override
  int get hashCode =>
      totalTasks.hashCode ^ completedTasks.hashCode ^ totalPages.hashCode ^ projectId.hashCode;
}
