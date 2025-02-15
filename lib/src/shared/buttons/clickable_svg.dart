import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppIconButton extends ConsumerWidget {
  const AppIconButton({
    required this.icon,
    super.key,
    this.color,
    this.onClick,
    this.size,
  });

  final IconData icon;
  final VoidCallback? onClick;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClick,
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      );
}
