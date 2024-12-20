import 'package:flutter/material.dart';

import 'shades.dart';

@immutable
class RoseShades extends Shades {
  const RoseShades();

  @override
  Color get shade50 => const Color(0xFFFFF1F2);

  @override
  Color get shade100 => const Color(0xFFFFE4E6);

  @override
  Color get shade200 => const Color(0xFFFECDD3);

  @override
  Color get shade300 => const Color(0xFFFDA4AF);

  @override
  Color get shade400 => const Color(0xFFFB7185);

  @override
  Color get shade500 => const Color(0xFFF43F5E);

  @override
  Color get shade600 => const Color(0xFFE11D48);

  @override
  Color get shade700 => const Color(0xFFBE123C);

  @override
  Color get shade800 => const Color(0xFF9F1239);

  @override
  Color get shade900 => const Color(0xFF881337);
}
