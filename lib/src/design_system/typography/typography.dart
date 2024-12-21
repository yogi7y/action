import 'package:flutter/material.dart';

import 'weights.dart';

@immutable
abstract class Fonts {
  const Fonts({
    required this.fontFamily,
    required this.text,
    required this.headline,
  });

  final String fontFamily;
  final TextSize text;
  final HeadlineSize headline;
}

@immutable
abstract class TextSize {
  TextWeights get lg;
  TextWeights get md;
  TextWeights get sm;
  TextWeights get xs;
}

@immutable
abstract class HeadlineSize {
  HeadlineWeights get xs;
  HeadlineWeights get sm;
  HeadlineWeights get md;
  HeadlineWeights get lg;
  HeadlineWeights get xl;
  HeadlineWeights get xxl;
}

@immutable
abstract class TextWeights implements Regular, Medium, Semibold {}

@immutable
abstract class HeadlineWeights implements Medium, Semibold, Bold {}
