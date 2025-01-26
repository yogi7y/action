import 'package:flutter/material.dart';

import '../../base/semantics/task_detail_overview_tile_token.dart';
import '../light_theme.dart';

@immutable
class LightTextDetailOverviewTileHasValueTokens extends LightBaseTheme
    implements TextDetailOverviewTileTokens {
  LightTextDetailOverviewTileHasValueTokens({required super.primitiveTokens});

  @override
  Color get border => const Color(0xFFE2E8F0).withValues(alpha: 0.7);

  @override
  Color get labelForeground => primitiveTokens.neutral.shade500;

  @override
  Color get valueForeground => textTokens.primary;
}

@immutable
class LightTextDetailOverviewTileNoValueTokens extends LightBaseTheme
    implements TextDetailOverviewTileTokens {
  LightTextDetailOverviewTileNoValueTokens({required super.primitiveTokens});

  @override
  Color get border => const Color(0xFFE2E8F0).withValues(alpha: 0.7);

  @override
  Color get labelForeground => primitiveTokens.neutral.shade500;

  @override
  Color get valueForeground => textTokens.tertiary;
}
