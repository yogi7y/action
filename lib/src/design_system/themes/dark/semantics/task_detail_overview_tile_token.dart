import 'package:flutter/material.dart';

import '../../base/semantics/task_detail_overview_tile_token.dart';
import '../dark_theme.dart';

@immutable
class DarkTextDetailOverviewTileHasValueTokens extends DarkBaseTheme
    implements TextDetailOverviewTileTokens {
  DarkTextDetailOverviewTileHasValueTokens({required super.primitiveTokens})
      : valueForeground = primitiveTokens.neutral.shade400, // textTokens.secondary
        labelForeground = primitiveTokens.neutral.shade500, // textTokens.tertiary
        border = const Color(0xFF1E293B).withValues(alpha: 0.7);

  @override
  final Color valueForeground;

  @override
  final Color labelForeground;

  @override
  final Color border;
}

@immutable
class DarkTextDetailOverviewTileNoValueTokens extends DarkBaseTheme
    implements TextDetailOverviewTileTokens {
  DarkTextDetailOverviewTileNoValueTokens({required super.primitiveTokens})
      : valueForeground = primitiveTokens.neutral.shade600,
        labelForeground = primitiveTokens.neutral.shade500, // textTokens.tertiary
        border = const Color(0xFF1E293B).withValues(alpha: 0.7);

  @override
  final Color valueForeground;

  @override
  final Color labelForeground;

  @override
  final Color border;
}
