import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/project.dart';
import '../../domain/repository/project_repository.dart';
import '../models/project_model.dart';

class SupabaseProjectRepository implements ProjectRepository {
  final _supabase = Supabase.instance.client;

  @override
  AsyncProjectsResult fetchProjects() async {
    try {
      final response =
          await _supabase.from('projects').select().order('created_at', ascending: false);

      final projects = (response as List<Object?>? ?? [])
          .map(
            (project) => ProjectModel.fromMap(project as Map<String, Object?>? ?? {}),
          )
          .toList();

      return Success(projects);
    } on PostgrestException catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  AsyncProjectResult getProjectById(ProjectId id) async {
    try {
      final response = await _supabase.from('projects').select().eq('id', id).single();

      return Success(ProjectModel.fromMap(response));
    } on PostgrestException catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.message,
          stackTrace: stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  AsyncProjectResult updateProject(ProjectEntity project) async {
    try {
      final response = await _supabase
          .from('projects')
          .update(project.toMap())
          .eq('id', project.id)
          .select()
          .single();

      return Success(ProjectModel.fromMap(response));
    } catch (e, stackTrace) {
      return Failure(
        AppException(
          exception: e.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
