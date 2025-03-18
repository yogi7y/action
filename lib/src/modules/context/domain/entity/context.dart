// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

@immutable
class ContextEntity implements Searchable {
  const ContextEntity({
    required this.name,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  String get stringifiedValue => name;

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
