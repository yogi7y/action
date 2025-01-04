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

@immutable
class AddTaskFloatingActionButton extends ConsumerStatefulWidget {
  const AddTaskFloatingActionButton({super.key});

  @override
  ConsumerState<AddTaskFloatingActionButton> createState() => _AddTaskFloatingActionButtonState();
}

class _AddTaskFloatingActionButtonState extends ConsumerState<AddTaskFloatingActionButton>
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

    final _stickyComponentHeight = ref.watch(stickyComponentHeightProvider);
    final _isKeyboardOpen = ref.watch(keyboardVisibilityProvider).value ?? false;

    final _bottomPadding = (_isKeyboardOpen ? _stickyComponentHeight ?? 0 : 0).toDouble();

    return Padding(
      padding: EdgeInsets.only(bottom: _bottomPadding),
      child: FloatingActionButton(
        onPressed: () async {
          ref.read(isTaskTextInputFieldVisibleProvider.notifier).update((value) => !value);
          await Future<void>.delayed(const Duration(milliseconds: 200));

          if (_animationController.status == AnimationStatus.completed) {
            unawaited(_animationController.reverse());
          } else {
            unawaited(_animationController.forward());
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
      ),
    );
  }
}
