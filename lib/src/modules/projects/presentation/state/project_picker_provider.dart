// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/project.dart';
import '../view_models/project_view_model.dart';
import 'projects_provider.dart';

/// Provider to hold the current search query for project picker
final projectPickerQueryProvider = StateProvider<String>((ref) => '');

/// Provider to filter projects based on the search query
final projectPickerResultsProvider = Provider.family<List<ProjectViewModel>, String>((ref, query) {
  final projectsAsync = ref.watch(projectsProvider);

  // Return all projects when loaded, empty list otherwise
  final allProjects = projectsAsync.valueOrNull ?? [];

  // If query is empty, return all projects
  if (query.isEmpty) return allProjects;

  // Filter projects based on query
  return allProjects
      .where((project) => project.project.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
});

/// Utility extension to sync TextEditingController with projectPickerQueryProvider
extension ProjectPickerTextControllerSync on TextEditingController {
  void syncWithProjectPickerQuery(WidgetRef ref) {
    // Listen to changes from the text controller and update the provider
    addListener(() {
      ref.read(projectPickerQueryProvider.notifier).state = text;
    });
  }
}

/// Provider to hold the currently selected project in the picker
final selectedProjectPickerProvider = StateProvider<ProjectViewModel?>((ref) => null);

final projectPickerDataProvider = Provider<ProjectPickerData>(
  (ref) => throw UnimplementedError('Ensure to override projectPickerDataProvider'),
  name: 'projectPickerDataProvider',
);

@immutable
class ProjectPickerData {
  const ProjectPickerData({
    required this.onProjectSelected,
    this.selectedProject,
    this.onRemove,
  });

  /// Called when a project is selected.
  final void Function(ProjectViewModel viewModel) onProjectSelected;

  /// Called when a project is removed.
  final void Function(ProjectViewModel viewModel)? onRemove;

  /// Selected project.
  final ProjectViewModel? selectedProject;

  @override
  String toString() => 'ProjectPickerData(onProjectSelected: $onProjectSelected)';

  @override
  bool operator ==(covariant ProjectPickerData other) {
    if (identical(this, other)) return true;

    return other.onProjectSelected == onProjectSelected;
  }

  @override
  int get hashCode => onProjectSelected.hashCode;
}
