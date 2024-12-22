import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/user.dart';
import '../repository/auth_repository.dart';

typedef UserResult = Result<UserEntity, AppException>;

class AuthUseCase {
  const AuthUseCase(this.repository);

  final AuthRepository repository;

  Future<UserResult> signInWithGoogle() async => repository.signInWithGoogle();

  bool get isSignedIn => repository.isSignedIn;

  Stream<UserCurrentState> get userCurrentState => repository.userCurrentState;

  Future<void> signOut() async => repository.signOut();
}

final authUseCaseProvider =
    Provider<AuthUseCase>((ref) => AuthUseCase(ref.watch(authRepositoryProvider)));
