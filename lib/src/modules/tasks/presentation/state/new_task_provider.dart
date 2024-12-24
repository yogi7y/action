import 'package:flutter_riverpod/flutter_riverpod.dart';

final isTaskTextInputFieldVisibleProvider = StateProvider<bool>((ref) => false);

/// holds the task entered by the user.
final newTaskTextProvider = StateProvider<String>((ref) => '');
