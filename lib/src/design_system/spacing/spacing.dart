import 'package:flutter/foundation.dart';

@immutable
abstract class Spacing {
  const Spacing();

  double get xxs;

  double get xs;

  double get sm;

  double get md;

  double get lg;

  double get xl;

  double get xxl;
}
