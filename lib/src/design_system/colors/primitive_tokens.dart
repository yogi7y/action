import 'package:flutter/material.dart';

import 'shades/neutral_shades.dart';
import 'shades/rose_shades.dart';
import 'shades/shades.dart';

@immutable
class PrimitiveColorTokens {
  const PrimitiveColorTokens({
    this.white = const Color(0xFFFFFFFF),
    this.dark = const Color(0xFF090F20),
    this.neutral = const NeutralShades(),
    this.rose = const RoseShades(),
  });

  final Color white;
  final Color dark;
  final Shades neutral;
  final Shades rose;
}
