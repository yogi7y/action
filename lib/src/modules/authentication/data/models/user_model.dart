import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entity/user.dart';

@immutable
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromSupabaseUser(User user) {
    final userMetaData = user.userMetadata ?? {};
    final fullName = userMetaData['full_name'] as String?;
    final name = userMetaData['name'] as String?;

    return UserModel(
      id: user.id,
      name: fullName ?? name ?? '',
      email: user.email ?? '',
    );
  }
}
