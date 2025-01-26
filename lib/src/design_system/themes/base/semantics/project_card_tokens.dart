// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
abstract class ProjectCardTokens {
  const ProjectCardTokens({
    required this.headerBackground,
    required this.background,
    required this.titleForeground,
    required this.subtitleForeground,
    required this.shadow,
  });

  final Color headerBackground;
  final Color background;
  final Color titleForeground;
  final Color subtitleForeground;
  final Color shadow;

  @override
  String toString() =>
      'ProjectCardTokens(headerBackground: $headerBackground, background: $background, titleForeground: $titleForeground, subtitleForeground: $subtitleForeground, shadow: $shadow)';
}
