import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/loader/shimmer.dart';

class TasksLoadingTile extends ConsumerWidget {
  const TasksLoadingTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _spacing = ref.watch(spacingProvider);
    final _width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing.lg,
        vertical: _spacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BaseShimmer(
            child: ShimmerBox(
              width: 32,
              height: 32,
              borderRadius: 8,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseShimmer(
                child: ShimmerBox(
                  width: _width * 0.75,
                  height: 20,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  BaseShimmer(
                    child: ShimmerBox(
                      width: _width * 0.3,
                      height: 12,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
