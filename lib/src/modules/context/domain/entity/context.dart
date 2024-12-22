import 'package:flutter/material.dart';

@immutable
class ContextEntity {
  const ContextEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContextEntity copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ContextEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  String toString() =>
      'ContextEntity(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  bool operator ==(covariant ContextEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
}
