import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/design_system.dart';

class PlaceholderWidget extends ConsumerWidget {
  const PlaceholderWidget({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fonts = ref.watch(fontsProvider);
    return Center(
      child: Text(
        text,
        style: fonts.headline.lg.medium,
      ),
    );
  }
}
