import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/supabase_context_repository.dart';
import '../entity/context.dart';

typedef ContextResult = Result<List<ContextEntity>, AppException>;
typedef AsyncContextResult = Future<ContextResult>;

abstract class ContextRepository {
  AsyncContextResult fetchContexts();
}

final contextRepositoryProvider = Provider<ContextRepository>(
  (ref) => SupabaseContextRepository(),
);
