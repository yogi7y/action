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
    final _userMetaData = user.userMetadata ?? {};
    final _fullName = _userMetaData['full_name'] as String?;
    final _name = _userMetaData['name'] as String?;

    return UserModel(
      id: user.id,
      name: _fullName ?? _name ?? '',
      email: user.email ?? '',
    );
  }
}
