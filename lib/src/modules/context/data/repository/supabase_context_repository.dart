import 'package:core_y/core_y.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repository/context_repository.dart';
import '../models/context.dart';

class SupabaseContextRepository implements ContextRepository {
  final _supabase = Supabase.instance.client;

  @override
  AsyncContextResult fetchContexts() async {
    try {
      final response =
          await _supabase.from('contexts').select().order('created_at', ascending: false);

      final contexts = (response as List<Object?>? ?? [])
          .map((context) => ContextModel.fromMap(context as Map<String, Object?>? ?? {}))
          .toList();

      return Success(contexts);
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
