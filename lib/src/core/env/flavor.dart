// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_implementing_value_types
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env.dart';

@immutable
abstract class AppFlavor {
  const AppFlavor({
    required this.env,
    required this.appName,
  });
  final Env env;
  final String appName;

  @override
  String toString() => 'AppFlavor(env: $env, appName: $appName)';

  @override
  bool operator ==(covariant AppFlavor other) {
    if (identical(this, other)) return true;

    return other.env == env && other.appName == appName;
  }

  @override
  int get hashCode => env.hashCode ^ appName.hashCode;
}

@immutable
class StagingApp extends AppFlavor {
  StagingApp() : super(env: StagingEnv(), appName: 'Action Staging');
}

@immutable
class ProductionApp extends AppFlavor {
  ProductionApp() : super(env: ProductionEnv(), appName: 'Action');
}

final appFlavorProvider = Provider<AppFlavor>((ref) =>
    throw UnimplementedError('Ensure to override appFlavorProvider at the root of your app'));
