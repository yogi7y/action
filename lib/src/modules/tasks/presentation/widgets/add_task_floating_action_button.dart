import 'dart:async';
import 'dart:math';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/sticky_component_over_keyboard/sticky_keyboard_provider.dart';
import '../../../dashboard/presentation/state/keyboard_visibility_provider.dart';
import '../state/new_task_provider.dart';

enum AddRemoveFloatingActionButtonState {
  add,
  remove,
}

typedef AddRemoveFloatingActionButtonCallback = void Function(
  AddRemoveFloatingActionButtonState state,
);

@immutable
class AddRemoveFloatingActionButton extends ConsumerStatefulWidget {
  const AddRemoveFloatingActionButton({
    super.key,
    this.onStateChanged,
  });

  final AddRemoveFloatingActionButtonCallback? onStateChanged;

  @override
  ConsumerState<AddRemoveFloatingActionButton> createState() => _AddTaskFloatingActionButtonState();
}

class _AddTaskFloatingActionButtonState extends ConsumerState<AddRemoveFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: defaultAnimationDuration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: pi / 2,
      end: pi / 4,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _colors = ref.watch(appThemeProvider);

    final _isKeyboardOpen = ref.watch(keyboardVisibilityProvider).value ?? false;

    if (_isKeyboardOpen) return const SizedBox.shrink();

    return FloatingActionButton(
      onPressed: () async {
        final _isAddFlow = _animationController.status == AnimationStatus.dismissed;

        if (_isAddFlow) {
          widget.onStateChanged?.call(AddRemoveFloatingActionButtonState.add);
          unawaited(_animationController.forward());
        } else {
          widget.onStateChanged?.call(AddRemoveFloatingActionButtonState.remove);
          unawaited(_animationController.reverse());
        }
      },
      backgroundColor: _colors.primary,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
      ),
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) => Transform.rotate(
          angle: _rotationAnimation.value,
          child: SvgPicture.asset(
            AssetsV2.plus,
            height: 32,
            width: 32,
          ),
        ),
      ),
    );
  }
}
