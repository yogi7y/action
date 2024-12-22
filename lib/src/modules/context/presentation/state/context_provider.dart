import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/context.dart';
import '../../domain/use_case/context_use_case.dart';

final contextsProvider = FutureProvider<List<ContextEntity>>((ref) async {
  final useCase = ref.watch(contextUseCaseProvider);
  final result = await useCase.fetchContexts();

  return result.fold(
    onSuccess: (contexts) => contexts,
    onFailure: (error) => throw error,
  );
});

final contextByIdProvider = Provider.family<ContextEntity?, String>((ref, contextId) {
  final contextsAsync = ref.watch(contextsProvider);

  return contextsAsync.whenOrNull(
    data: (contexts) => contexts.firstWhereOrNull((context) => context.id == contextId),
  );
});
