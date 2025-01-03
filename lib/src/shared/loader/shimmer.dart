import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../design_system/design_system.dart';

class BaseShimmer extends ConsumerWidget {
  const BaseShimmer({
    required this.child,
    this.width,
    this.height,
    super.key,
  });

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);

    return Shimmer.fromColors(
      baseColor: _colors.accentShade,
      highlightColor: _colors.surface.modals,
      child: child,
    );
  }
}

// Reusable shimmer shapes
class ShimmerBox extends ConsumerWidget {
  const ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 4,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: borderRadius,
            cornerSmoothing: 1,
          ),
        ),
      ),
    );
  }
}

class ShimmerCircle extends ConsumerWidget {
  const ShimmerCircle({
    required this.size,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
