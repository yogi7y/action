import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/supabase_project_repository.dart';
import '../entity/project.dart';

typedef ProjectResult = Result<List<ProjectEntity>, AppException>;
typedef AsyncProjectResult = Future<ProjectResult>;

abstract class ProjectRepository {
  AsyncProjectResult fetchProjects();
}

final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => SupabaseProjectRepository(),
);
