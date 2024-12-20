import 'package:flutter/material.dart';

import 'shades.dart';

@immutable
class NeutralShades extends Shades {
  const NeutralShades();

  @override
  Color get shade50 => const Color(0xFFF8FAFC);

  @override
  Color get shade100 => const Color(0xFFF1F5F9);

  @override
  Color get shade200 => const Color(0xFFE2E8F0);

  @override
  Color get shade300 => const Color(0xFFCBD5E1);

  @override
  Color get shade400 => const Color(0xFF94A3B8);

  @override
  Color get shade500 => const Color(0xFF64748B);

  @override
  Color get shade600 => const Color(0xFF475569);

  @override
  Color get shade700 => const Color(0xFF334155);

  @override
  Color get shade800 => const Color(0xFF1E293B);

  @override
  Color get shade900 => const Color(0xFF0F172A);
}
