import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

@immutable
class AppIconButton extends ConsumerWidget {
  const AppIconButton({
    required this.svgIconPath,
    super.key,
    this.color,
    this.onClick,
    this.size,
  });

  final String svgIconPath;
  final VoidCallback? onClick;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: SvgPicture.asset(
        svgIconPath,
        width: size,
        height: size,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }
}
