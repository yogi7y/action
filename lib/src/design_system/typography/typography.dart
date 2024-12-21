import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../themes/base/theme.dart';
import 'mobile_fonts.dart';
import 'weights.dart';

final fontsProvider = Provider<Fonts>((ref) {
  final _colors = ref.watch(colorsProvider);
  return MobileFonts(colors: _colors);
});

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
