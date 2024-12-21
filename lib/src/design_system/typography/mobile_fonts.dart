import 'package:flutter/material.dart';

import 'typography.dart';

@immutable
class MobileFonts implements Fonts {
  const MobileFonts({
    this.fontFamily = 'Inter',
  });

  @override
  final String fontFamily;

  @override
  TextSize get text => MobileTextSize();

  @override
  HeadlineSize get headline => MobileHeadlineSize();
}

class MobileTextSize extends MobileFonts implements TextSize {
  MobileTextSize({
    super.fontFamily,
  })  : lg = TextLarge(),
        md = TextMedium(),
        sm = TextSmall(),
        xs = TextXSmall();

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
class TextLarge extends MobileFonts implements TextWeights {
  TextLarge({super.fontFamily})
      : regular = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 28 / 18,
          fontWeight: FontWeight.w400,
        ),
        medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 28 / 18,
          fontWeight: FontWeight.w500,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 28 / 18,
          fontWeight: FontWeight.w600,
        );

  @override
  final TextStyle regular;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;
}

@immutable
class TextMedium extends MobileFonts implements TextWeights {
  TextMedium({super.fontFamily})
      : regular = TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
        ),
        medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w500,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w600,
        );

  @override
  final TextStyle regular;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;
}

@immutable
class TextSmall extends MobileFonts implements TextWeights {
  TextSmall({super.fontFamily})
      : regular = TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
        ),
        medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w600,
        );

  @override
  final TextStyle regular;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;
}

@immutable
class TextXSmall extends MobileFonts implements TextWeights {
  TextXSmall({super.fontFamily})
      : regular = TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w400,
        ),
        medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w600,
        );

  @override
  final TextStyle regular;

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;
}

class MobileHeadlineSize extends MobileFonts implements HeadlineSize {
  MobileHeadlineSize({
    super.fontFamily,
  })  : xxl = HeadlineXxl(),
        xl = HeadlineXl(),
        lg = HeadlineLg(),
        md = HeadlineMd(),
        sm = HeadlineSm(),
        xs = HeadlineXs();

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
class HeadlineXxl extends MobileFonts implements HeadlineWeights {
  HeadlineXxl({super.fontFamily})
      : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 36,
          height: 44 / 36, // 44sp line height
          fontWeight: FontWeight.w500,
          letterSpacing: -0.02,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 36,
          height: 44 / 36,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 36,
          height: 44 / 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
        );

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineXl extends MobileFonts implements HeadlineWeights {
  HeadlineXl({super.fontFamily})
      : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.02,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
        );

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineLg extends MobileFonts implements HeadlineWeights {
  HeadlineLg({super.fontFamily})
      : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          height: 36 / 28,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.02,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          height: 36 / 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          height: 36 / 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
        );

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineMd extends MobileFonts implements HeadlineWeights {
  HeadlineMd({super.fontFamily})
      : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.02,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
        );

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineSm extends MobileFonts implements HeadlineWeights {
  HeadlineSm({super.fontFamily})
      : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.02,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
        );

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}

@immutable
class HeadlineXs extends MobileFonts implements HeadlineWeights {
  HeadlineXs({super.fontFamily})
      : medium = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 24 / 18,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.02,
        ),
        semibold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 24 / 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02,
        ),
        bold = TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          height: 24 / 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
        );

  @override
  final TextStyle medium;

  @override
  final TextStyle semibold;

  @override
  final TextStyle bold;
}
