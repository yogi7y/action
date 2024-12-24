import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StickyTextField extends ConsumerWidget {
  const StickyTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Search Project',
        border: InputBorder.none,
      ),
    );
  }
}
