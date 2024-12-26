import 'package:flutter/material.dart';

import '../../domain/entity/project.dart';

@immutable
class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProjectModel.fromMap(Map<String, Object?> map) => ProjectModel(
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
