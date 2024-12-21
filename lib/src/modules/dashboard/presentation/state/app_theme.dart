import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/colors/primitive_tokens.dart';
import '../../../../design_system/themes/base/theme.dart';
import '../../../../design_system/themes/light/light_theme.dart';

final appTheme = StateProvider<ComponentThemes>((ref) => LightTheme(
      primitiveTokens: const PrimitiveColorTokens(),
    ));
