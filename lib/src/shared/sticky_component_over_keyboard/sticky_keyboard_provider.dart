import 'package:flutter_riverpod/flutter_riverpod.dart';

final showStickyTextFieldProvider = Provider<bool>((ref) {
  final _showProject = ref.watch(showProjectStickyTextFieldProvider);
  final _showContext = ref.watch(showContextStickyTextFieldProvider);

  return _showProject || _showContext;
});

final showProjectStickyTextFieldProvider = StateProvider<bool>((ref) => false);
final showContextStickyTextFieldProvider = StateProvider<bool>((ref) => false);

final stickyComponentHeightProvider = StateProvider<double?>((ref) => null);
