import 'package:flutter/foundation.dart';

import '../../domain/entity/project.dart';

@immutable
class ProjectViewModel {
  const ProjectViewModel({
    required this.project,
    required this.totalTasks,
    required this.completedTasks,
    required this.totalPages,
  });

  /// Current project related data
  final ProjectEntity project;

  /// Total tasks in the project
  final int totalTasks;

  /// Total completed tasks in the project
  final int completedTasks;

  /// Total pages in the project
  final int totalPages;

  ProjectViewModel copyWith({
    ProjectEntity? project,
    int? totalTasks,
    int? completedTasks,
    int? totalPages,
  }) =>
      ProjectViewModel(
        project: project ?? this.project,
        totalTasks: totalTasks ?? this.totalTasks,
        completedTasks: completedTasks ?? this.completedTasks,
        totalPages: totalPages ?? this.totalPages,
      );

  @override
  String toString() =>
      'ProjectViewModel(project: $project, totalTasks: $totalTasks, completedTasks: $completedTasks, totalPages: $totalPages)';

  @override
  bool operator ==(covariant ProjectViewModel other) {
    if (identical(this, other)) return true;

    return other.project == project &&
        other.totalTasks == totalTasks &&
        other.completedTasks == completedTasks &&
        other.totalPages == totalPages;
  }

  @override
  int get hashCode =>
      project.hashCode ^ totalTasks.hashCode ^ completedTasks.hashCode ^ totalPages.hashCode;
}
