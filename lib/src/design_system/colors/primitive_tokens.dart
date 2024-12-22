import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shades/neutral_shades.dart';
import 'shades/rose_shades.dart';
import 'shades/shades.dart';

final primitiveTokensProvider =
    Provider<PrimitiveColorTokens>((ref) => const PrimitiveColorTokens());

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
