import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/themes/base/theme.dart';
import '../../../../design_system/themes/dark/dark_theme.dart';

/// Provider that manages system UI styles based on the current theme
final systemUiControllerProvider = Provider((ref) {
  final _colors = ref.watch(appThemeProvider);
  final _isDark = _colors is DarkTheme;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: _isDark ? Brightness.dark : Brightness.light,
      // Match navigation bar with bottom nav background color
      systemNavigationBarColor: _colors.unselectedBottomNavigationItem.background,
      systemNavigationBarIconBrightness: _isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
});
