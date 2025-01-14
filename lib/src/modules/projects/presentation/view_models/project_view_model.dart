import 'package:flutter/foundation.dart';

import '../../domain/entity/project.dart';

@immutable
class ProjectViewModel {
  const ProjectViewModel({
    required this.project,
    required this.totalTasks,
    required this.totalPages,
  });

  final ProjectEntity project;
  final int totalTasks;
  final int totalPages;

  ProjectViewModel copyWith({
    ProjectEntity? project,
    int? totalTasks,
    int? totalPages,
  }) =>
      ProjectViewModel(
        project: project ?? this.project,
        totalTasks: totalTasks ?? this.totalTasks,
        totalPages: totalPages ?? this.totalPages,
      );

  @override
  bool operator ==(covariant ProjectViewModel other) {
    if (identical(this, other)) return true;

    return other.project == project &&
        other.totalTasks == totalTasks &&
        other.totalPages == totalPages;
  }

  @override
  int get hashCode => project.hashCode ^ totalTasks.hashCode ^ totalPages.hashCode;
}
