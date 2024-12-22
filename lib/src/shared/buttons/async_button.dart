import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncButton extends ConsumerWidget {
  const AsyncButton({required this.text, required this.onClick, super.key});

  final String text;
  final AsyncCallback onClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
    );
  }
}
