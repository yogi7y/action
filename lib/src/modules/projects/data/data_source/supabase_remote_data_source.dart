import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/extensions/list_extension.dart';
import '../../../../core/logger/logger.dart';
import '../../domain/repository/project_repository.dart';
import '../models/project_model.dart';
import '../models/project_relation_metadata_model.dart';
import 'project_remote_data_source.dart';

@immutable
class SupabaseProjectRemoteDataSource implements ProjectRemoteDataSource {
  SupabaseProjectRemoteDataSource({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  @override
  Future<List<ProjectModel>> fetchProjects() async {
    final response =
        await _supabase.from('projects').select().order('created_at', ascending: false);

    return (response as List<Object?>? ?? []).tryMap<ProjectModel>(ProjectModel.fromMap);
  }

  @override
  Future<ProjectModel> getProjectById(ProjectId id) async {
    final response = await _supabase.from('projects').select().eq('id', id).single();

    return ProjectModel.fromMap(response);
  }

  @override
  Future<ProjectModel> updateProject(Map<String, dynamic> projectData, ProjectId id) async {
    final response =
        await _supabase.from('projects').update(projectData).eq('id', id).select().single();

    return ProjectModel.fromMap(response);
  }

  @override
  Future<ProjectRelationMetadataModel> getProjectRelationMetadata(String projectId) async {
    final response = await _supabase.rpc<Map<String, Object?>>(
      'get_project_relation_metadata',
      params: {'project_id': projectId},
    );

    final metadata = ProjectRelationMetadataModel.fromMap(response);

    return metadata;
  }

  @override
  Future<List<(ProjectModel, ProjectRelationMetadataModel)>> fetchProjectsWithMetadata() async {
    try {
      final response = await _supabase.rpc<List<Object?>>(
        'get_projects_with_metadata',
      );

      return response.map((e) {
        final map = e as Map<String, Object?>? ?? {};

        return (
          ProjectModel.fromMap(map['project'] as Map<String, Object?>? ?? {}),
          ProjectRelationMetadataModel.fromMap(
              map['relation_metadata'] as Map<String, Object?>? ?? {})
        );
      }).toList();
    } catch (e) {
      logger('fetchProjectsWithMetadata error: $e');
      rethrow;
    }
  }
}
