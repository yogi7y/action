import 'dart:developer' as developer;

import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repository/project_repository.dart';
import '../models/project_model.dart';

class SupabaseProjectRepository implements ProjectRepository {
  final _supabase = Supabase.instance.client;

  @override
  AsyncProjectResult fetchProjects() async {
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
}
