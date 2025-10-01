import 'package:flutter/foundation.dart';

import 'spacing.dart';

@immutable
class MobileSpacing extends Spacing {
  const MobileSpacing();

  @override
  double get xxs => 4;

  @override
  double get xs => 8;

  @override
  double get sm => 12;

  @override
  double get md => 16;

  @override
  double get lg => 20;

  @override
  double get xl => 24;

  @override
  double get xxl => 28;
}
