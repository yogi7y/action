import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/auth_repository.dart';
import '../../domain/use_case/auth_use_case.dart';

final authStateProvider = StreamProvider<UserCurrentState>((ref) {
  final repository = ref.watch(authUseCaseProvider);
  return repository.userCurrentState;
});
