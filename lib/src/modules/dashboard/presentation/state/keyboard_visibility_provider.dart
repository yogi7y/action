import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final keyboardVisibilityProvider = StreamProvider<bool>((ref) {
  final keyboardVisibilityController = KeyboardVisibilityController();
  return keyboardVisibilityController.onChange;
});
