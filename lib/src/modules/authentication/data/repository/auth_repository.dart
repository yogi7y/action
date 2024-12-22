import 'dart:developer' as developer;
import 'package:core_y/core_y.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/env/env.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../models/user_model.dart';

class SupabaseAuthRepository implements AuthRepository {
  late final _supabaseAuth = Supabase.instance.client.auth;

  @override
  Future<Result<UserEntity, AppException>> signInWithGoogle() async {
    final _googleSignIn = GoogleSignIn(
      serverClientId: Env.googleWebClientId,
    );

    final _user = await _googleSignIn.signIn();

    final _googleAuth = await _user?.authentication;
    final _accessToken = _googleAuth?.accessToken;
    final _idToken = _googleAuth?.idToken;

    if (_accessToken == null) {
      return Failure(
        AppException(exception: 'Access token is null', stackTrace: StackTrace.current),
      );
    }

    if (_idToken == null) {
      return Failure(
        AppException(exception: 'Id token is null', stackTrace: StackTrace.current),
      );
    }

    final _result = await _supabaseAuth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: _idToken,
      accessToken: _accessToken,
    );

    throw UnimplementedError();
  }

  @override
  bool get isSignedIn => _supabaseAuth.currentSession != null;

  @override
  Future<Result<void, AppException>> signOut() async {
    await _supabaseAuth.signOut();
    return const Success(null);
  }

  @override
  Stream<UserCurrentState> get userCurrentState {
    return _supabaseAuth.onAuthStateChange
        .map((state) {
          final session = state.session;
          final user = session?.user;

          if (user == null) return (isSignedIn: false, user: null);

          return (
            isSignedIn: true,
            user: UserModel.fromSupabaseUser(user),
          );
        })
        .distinct(
          (previous, current) =>
              previous.isSignedIn == current.isSignedIn && previous.user == current.user,
        )
        .doOnData((event) {
          developer.log('User current state: $event');
        });
  }
}
