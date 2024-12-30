// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as developer;

import 'package:core_y/core_y.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/env/env.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../models/user_model.dart';

@immutable
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    required this.env,
  });

  final Env env;

  late final _supabaseAuth = Supabase.instance.client.auth;

  @override
  Future<Result<UserEntity, AppException>> signInWithGoogle() async {
    final iOSClientId = env.googleIosClientId;

    final _googleSignIn = GoogleSignIn(
      clientId: iOSClientId,
      serverClientId: env.googleWebClientId,
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

    final _response = await _supabaseAuth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: _idToken,
      accessToken: _accessToken,
    );

    if (_response.user == null)
      return Failure(AppException(
        exception: 'User should not be null',
        stackTrace: StackTrace.current,
      ));

    final _userResult = UserModel.fromSupabaseUser(_response.user!);

    return Success(_userResult);
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
