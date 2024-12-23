import 'package:flutter/material.dart';

import '../themes/base/theme.dart';
import 'typography.dart';

const interFontFamily = 'Inter';

const _regularVariation = [
  FontVariation.weight(400),
];

const _mediumVariation = [
  FontVariation.weight(500),
];

const _semiboldVariation = [
  FontVariation.weight(600),
];

const _boldVariation = [
  FontVariation.weight(700),
];

@immutable
class MobileFonts implements Fonts {
  MobileFonts({
    required this.colors,
    this.fontFamily = interFontFamily,
  })  : text = MobileTextSize(colors: colors, fontFamily: fontFamily),
        headline = MobileHeadlineSize(colors: colors, fontFamily: fontFamily);

  @override
  final String fontFamily;

  final AppTheme colors;

  @override
  final TextSize text;
  @override
  final HeadlineSize headline;
}

class MobileTextSize implements TextSize {
  MobileTextSize({
    required this.colors,
    required this.fontFamily,
  })  : lg = TextLarge(colors: colors, fontFamily: fontFamily),
        md = TextMedium(colors: colors, fontFamily: fontFamily),
        sm = TextSmall(colors: colors, fontFamily: fontFamily),
        xs = TextXSmall(colors: colors, fontFamily: fontFamily);

  final AppTheme colors;
  final String? fontFamily;

  @override
  final TextWeights lg;

  @override
  final TextWeights md;

  @override
  final TextWeights sm;

  @override
  final TextWeights xs;
}

@immutable
class TextLarge implements TextWeights {
  TextLarge({
    required this.colors,
    required this.fontFamily,
  })  : regular = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 28 / 18,
          fontVariations: _regularVariation,
          color: colors.textTokens.primary,
        ),
        medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 28 / 18,
          fontVariations: _mediumVariation,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 28 / 18,
          fontVariations: _semiboldVariation,
          color: colors.textTokens.primary,
        );

  final AppTheme colors;
  final String? fontFamily;
  @override
  final TextStyle regular;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;
}

@immutable
class TextMedium implements TextWeights {
  TextMedium({
    required this.colors,
    required this.fontFamily,
  })  : regular = TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          height: 24 / 16,
          fontVariations: _regularVariation,
          color: colors.textTokens.primary,
        ),
        medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          height: 24 / 16,
          fontVariations: _mediumVariation,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          height: 24 / 16,
          fontVariations: _semiboldVariation,
          color: colors.textTokens.primary,
        );
  final AppTheme colors;
  final String? fontFamily;
  @override
  final TextStyle regular;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;
}

@immutable
class TextSmall implements TextWeights {
  TextSmall({
    required this.colors,
    required this.fontFamily,
  })  : regular = TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 20 / 14,
          fontVariations: _regularVariation,
          color: colors.textTokens.primary,
        ),
        medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 20 / 14,
          fontVariations: _mediumVariation,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 20 / 14,
          fontVariations: _semiboldVariation,
          color: colors.textTokens.primary,
        );
  final AppTheme colors;
  final String? fontFamily;
  @override
  final TextStyle regular;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;
}

@immutable
class TextXSmall implements TextWeights {
  TextXSmall({
    required this.colors,
    required this.fontFamily,
  })  : regular = TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 16 / 12,
          fontVariations: _regularVariation,
          color: colors.textTokens.primary,
        ),
        medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 16 / 12,
          fontVariations: _mediumVariation,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 16 / 12,
          fontVariations: _semiboldVariation,
          color: colors.textTokens.primary,
        );
  final AppTheme colors;
  final String? fontFamily;
  @override
  final TextStyle regular;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;
}

class MobileHeadlineSize implements HeadlineSize {
  MobileHeadlineSize({
    required this.colors,
    required this.fontFamily,
  })  : xxl = HeadlineXxl(colors: colors, fontFamily: fontFamily),
        xl = HeadlineXl(colors: colors, fontFamily: fontFamily),
        lg = HeadlineLg(colors: colors, fontFamily: fontFamily),
        md = HeadlineMd(colors: colors, fontFamily: fontFamily),
        sm = HeadlineSm(colors: colors, fontFamily: fontFamily),
        xs = HeadlineXs(colors: colors, fontFamily: fontFamily);

  final AppTheme colors;
  final String? fontFamily;
  @override
  final HeadlineWeights xxl;

  @override
  final HeadlineWeights xl;

  @override
  final HeadlineWeights lg;

  @override
  final HeadlineWeights md;

  @override
  final HeadlineWeights sm;

  @override
  final HeadlineWeights xs;
}

@immutable
class HeadlineXxl implements HeadlineWeights {
  HeadlineXxl({
    required this.colors,
    required this.fontFamily,
  })  : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 36,
          height: 44 / 36,
          fontVariations: _mediumVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 36,
          height: 44 / 36,
          fontVariations: _semiboldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 36,
          height: 44 / 36,
          fontVariations: _boldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        );

  final AppTheme colors;
  final String? fontFamily;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineXl implements HeadlineWeights {
  HeadlineXl({
    required this.colors,
    required this.fontFamily,
  })  : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          height: 40 / 32,
          fontVariations: _mediumVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          height: 40 / 32,
          fontVariations: _semiboldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          height: 40 / 32,
          fontVariations: _boldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        );
  final AppTheme colors;
  final String? fontFamily;
  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineLg implements HeadlineWeights {
  HeadlineLg({
    required this.colors,
    required this.fontFamily,
  })  : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          height: 36 / 28,
          fontVariations: _mediumVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          height: 36 / 28,
          fontVariations: _semiboldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          height: 36 / 28,
          fontVariations: _boldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        );

  final AppTheme colors;
  final String? fontFamily;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineMd implements HeadlineWeights {
  HeadlineMd({
    required this.colors,
    required this.fontFamily,
  })  : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          height: 32 / 24,
          fontVariations: _mediumVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          height: 32 / 24,
          fontVariations: _semiboldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          height: 32 / 24,
          fontVariations: _boldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        );

  final AppTheme colors;
  final String? fontFamily;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineSm implements HeadlineWeights {
  HeadlineSm({
    required this.colors,
    required this.fontFamily,
  })  : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          height: 28 / 20,
          fontVariations: _mediumVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          height: 28 / 20,
          fontVariations: _semiboldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          height: 28 / 20,
          fontVariations: _boldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        );

  final AppTheme colors;
  final String? fontFamily;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineXs implements HeadlineWeights {
  HeadlineXs({
    required this.colors,
    required this.fontFamily,
  })  : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 24 / 18,
          fontVariations: _mediumVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 24 / 18,
          fontVariations: _semiboldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 24 / 18,
          fontVariations: _boldVariation,
          letterSpacing: -0.02,
          color: colors.textTokens.primary,
        );

  final AppTheme colors;
  final String? fontFamily;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}
