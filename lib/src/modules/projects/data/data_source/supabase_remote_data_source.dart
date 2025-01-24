import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/extensions/list_extension.dart';
import '../../domain/repository/project_repository.dart';
import '../models/project_model.dart';
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
}
