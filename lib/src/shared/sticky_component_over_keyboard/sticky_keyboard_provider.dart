import 'package:flutter_riverpod/flutter_riverpod.dart';

final showStickyTextFieldProvider = Provider.autoDispose<bool>((ref) {
  return false;
  // final currentStickyTextFieldType = ref.watch(currentStickyTextFieldTypeProvider);
  // return currentStickyTextFieldType != null;
});

enum StickyTextFieldType { project, context }

final currentStickyTextFieldTypeProvider = StateProvider<StickyTextFieldType?>((ref) => null);

final stickyComponentHeightProvider = StateProvider<double?>((ref) => null);
