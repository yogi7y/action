import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../../services/database/model_meta_data.dart';

@immutable
class ContextPropertiesEntity {
  const ContextPropertiesEntity({
    required this.name,
  });

  final String name;

  ContextPropertiesEntity copyWith({
    String? name,
  }) =>
      ContextPropertiesEntity(
        name: name ?? this.name,
      );

  Map<String, Object?> toMap() => {
        'name': name,
      };

  @override
  String toString() => 'ContextPropertiesEntity(name: $name)';

  @override
  bool operator ==(covariant ContextPropertiesEntity other) {
    if (identical(this, other)) return true;

    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

@immutable
class ContextEntity extends ContextPropertiesEntity implements ModelMetaData, Searchable {
  const ContextEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required super.name,
  });

  factory ContextEntity.fromContextProperties({
    required ContextPropertiesEntity context,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Id id,
  }) =>
      ContextEntity(
        id: id,
        name: context.name,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  @override
  final Id id;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  @override
  String get stringifiedValue => name;

  @override
  ContextEntity copyWith({
    Id? id,
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
