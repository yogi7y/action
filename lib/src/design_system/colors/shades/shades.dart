import 'package:flutter/material.dart';

/// Base class for color shades from 50 to 900
@immutable
abstract class Shades {
  const Shades();

  Color get shade50;

  Color get shade100;

  Color get shade200;

  Color get shade300;

  Color get shade400;

  Color get shade500;

  Color get shade600;

  Color get shade700;

  Color get shade800;

  Color get shade900;

  /// Returns all shades as a map with their respective values
  Map<int, Color> get values => {
        50: shade50,
        100: shade100,
        200: shade200,
        300: shade300,
        400: shade400,
        500: shade500,
        600: shade600,
        700: shade700,
        800: shade800,
        900: shade900,
      };
}
