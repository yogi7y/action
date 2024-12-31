// // ignore_for_file: avoid_classes_with_only_static_members

import 'package:envied/envied.dart';
import 'package:flutter/foundation.dart';

part 'env.g.dart';

@immutable
sealed class Env {
  abstract final String supabaseUrl;
  abstract final String supabaseAnonKey;
  abstract final String googleWebClientId;
  abstract final String googleIosClientId;
}

@Envied(path: '.env.staging', obfuscate: true)
class StagingEnv implements Env {
  @override
  @EnviedField(varName: 'SUPABASE_URL')
  final String supabaseUrl = _StagingEnv.supabaseUrl;

  @override
  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  final String supabaseAnonKey = _StagingEnv.supabaseAnonKey;

  @override
  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID')
  final String googleWebClientId = _StagingEnv.googleWebClientId;

  @override
  @EnviedField(varName: 'GOOGLE_IOS_CLIENT_ID')
  final String googleIosClientId = _StagingEnv.googleIosClientId;
}

@Envied(path: '.env.production', obfuscate: true)
class ProductionEnv implements Env {
  @override
  @EnviedField(varName: 'SUPABASE_URL')
  final String supabaseUrl = _ProductionEnv.supabaseUrl;

  @override
  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  final String supabaseAnonKey = _ProductionEnv.supabaseAnonKey;

  @override
  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID')
  final String googleWebClientId = _ProductionEnv.googleWebClientId;

  @override
  @EnviedField(varName: 'GOOGLE_IOS_CLIENT_ID')
  final String googleIosClientId = _ProductionEnv.googleIosClientId;
}

@Envied(path: '.env', obfuscate: true)
class LocalEnv implements Env {
  @override
  @EnviedField(varName: 'SUPABASE_URL')
  final String supabaseUrl = _LocalEnv.supabaseUrl;

  @override
  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  final String supabaseAnonKey = _LocalEnv.supabaseAnonKey;

  @override
  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID')
  final String googleWebClientId = _LocalEnv.googleWebClientId;

  @override
  @EnviedField(varName: 'GOOGLE_IOS_CLIENT_ID')
  final String googleIosClientId = _LocalEnv.googleIosClientId;
}
