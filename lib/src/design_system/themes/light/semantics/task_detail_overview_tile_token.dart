import 'package:flutter/material.dart';

import '../../base/semantics/task_detail_overview_tile_token.dart';
import '../light_theme.dart';

@immutable
class LightTextDetailOverviewTileHasValueTokens extends LightBaseTheme
    implements TextDetailOverviewTileTokens {
  LightTextDetailOverviewTileHasValueTokens({required super.primitiveTokens})
      : valueForeground = primitiveTokens.neutral.shade400, // textTokens.secondary
        labelForeground = primitiveTokens.neutral.shade500,
        border = const Color(0xFFE2E8F0).withValues(alpha: 0.7);

  @override
  final Color valueForeground;

  @override
  final Color labelForeground;

  @override
  final Color border;
}

@immutable
class LightTextDetailOverviewTileNoValueTokens extends LightBaseTheme
    implements TextDetailOverviewTileTokens {
  LightTextDetailOverviewTileNoValueTokens({required super.primitiveTokens})
      : valueForeground = primitiveTokens.neutral.shade400, // textTokens.tertiary
        labelForeground = primitiveTokens.neutral.shade500,
        border = const Color(0xFFE2E8F0).withValues(alpha: 0.7);

  @override
  final Color valueForeground;

  @override
  final Color labelForeground;

  @override
  final Color border;
}
