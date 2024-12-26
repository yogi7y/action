// lib/src/modules/context/data/models/context.dart

import 'package:flutter/material.dart';

import '../../domain/entity/context.dart';

@immutable
class ContextModel extends ContextEntity {
  const ContextModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ContextModel.fromMap(Map<String, Object?> map) => ContextModel(
        id: map['id'] as String,
        name: map['name'] as String,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
