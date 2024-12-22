import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mobile_spacing.dart';

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

final spacingProvider = Provider<Spacing>((ref) => const MobileSpacing());
