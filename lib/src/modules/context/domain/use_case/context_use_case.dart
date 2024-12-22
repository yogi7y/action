import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/context_repository.dart';

class ContextUseCase {
  const ContextUseCase(this.repository);

  final ContextRepository repository;

  AsyncContextResult fetchContexts() => repository.fetchContexts();
}

final contextUseCaseProvider = Provider<ContextUseCase>(
  (ref) => ContextUseCase(ref.watch(contextRepositoryProvider)),
);
