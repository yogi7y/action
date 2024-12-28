import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';

class ContextScreen extends ConsumerWidget {
  const ContextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _color = ref.watch(appThemeProvider);
    return Center(
      child: Text(
        'Context',
        style: TextStyle(
          color: _color.textTokens.primary,
        ),
      ),
    );
  }
}
