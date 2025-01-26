import 'package:flutter/material.dart';

import '../../base/semantics/task_detail_overview_tile_token.dart';
import '../dark_theme.dart';

@immutable
class DarkTextDetailOverviewTileHasValueTokens extends DarkBaseTheme
    implements TextDetailOverviewTileTokens {
  DarkTextDetailOverviewTileHasValueTokens({
    required super.primitiveTokens,
  });

  @override
  Color get border => const Color(0xFF1E293B).withValues(alpha: 0.7);

  @override
  Color get labelForeground => textTokens.secondary;

  @override
  Color get valueForeground => textTokens.primary;
}

@immutable
class DarkTextDetailOverviewTileNoValueTokens extends DarkBaseTheme
    implements TextDetailOverviewTileTokens {
  DarkTextDetailOverviewTileNoValueTokens({required super.primitiveTokens});

  @override
  Color get valueForeground => textTokens.secondary;

  @override
  Color get labelForeground => textTokens.secondary;

  @override
  Color get border => const Color(0xFF1E293B).withValues(alpha: 0.7);
}
