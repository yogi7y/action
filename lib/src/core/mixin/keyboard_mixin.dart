import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/dashboard/presentation/state/keyboard_visibility_provider.dart';

mixin KeyboardMixin {
  bool isKeyboardOpen(WidgetRef ref) => ref.watch(keyboardVisibilityProvider).valueOrNull ?? false;
}
