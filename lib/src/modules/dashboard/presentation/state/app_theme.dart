import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/themes/base/theme.dart';
import '../../../../design_system/themes/dark/dark_theme.dart';
import '../../../../design_system/themes/light/light_theme.dart';

enum AppThemeType { light, dark }

final appThemeProvider = NotifierProvider<AppThemeNotifier, AppTheme>(AppThemeNotifier.new);

class AppThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() {
    final _darkTheme = ref.watch(darkThemeColorsProvider);
    final _lightTheme = ref.watch(lightThemeColorsProvider);
    return _lightTheme;
  }

  void toggle() {
    final _darkTheme = ref.watch(darkThemeColorsProvider);
    final _lightTheme = ref.watch(lightThemeColorsProvider);

    state = state is LightTheme ? _darkTheme : _lightTheme;
  }
}
