import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/env/flavor.dart';
import '../../data/repository/auth_repository.dart';
import '../entity/user.dart';

typedef UserCurrentState = ({bool isSignedIn, UserEntity? user});
typedef Email = String;
typedef Password = String;

abstract class AuthRepository {
  Future<Result<UserEntity, AppException>> signInWithGoogle();

  Future<Result<UserEntity, AppException>> signInWithEmailAndPassword({
    required Email email,
    required Password password,
  });

  Future<Result<void, AppException>> signOut();

  bool get isSignedIn;

  Stream<UserCurrentState> get userCurrentState;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final _appFlavor = ref.watch(appFlavorProvider);
  return SupabaseAuthRepository(env: _appFlavor.env);
});
