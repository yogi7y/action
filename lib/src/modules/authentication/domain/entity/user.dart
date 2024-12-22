// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

@immutable
class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
  }) =>
      UserEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
      );

  @override
  String toString() => 'UserEntity(id: $id, name: $name, email: $email)';

  @override
  bool operator ==(covariant UserEntity other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode;
}
