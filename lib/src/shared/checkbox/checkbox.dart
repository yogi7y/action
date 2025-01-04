import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../design_system/design_system.dart';
import '../../modules/tasks/domain/entity/task.dart';

typedef AppCheckboxChangedCallback = void Function(AppCheckboxState state);

enum AppCheckboxState {
  unchecked(),
  intermediate(),
  checked();

  const AppCheckboxState();

  factory AppCheckboxState.fromBool({bool value = false}) =>
      value ? AppCheckboxState.checked : AppCheckboxState.unchecked;

  factory AppCheckboxState.fromTaskStatus({required TaskStatus status}) {
    switch (status) {
      case TaskStatus.done:
        return AppCheckboxState.checked;

      case TaskStatus.inProgress:
        return AppCheckboxState.intermediate;

      case TaskStatus.todo:
        return AppCheckboxState.unchecked;
    }
  }
}

@immutable
class AppCheckbox extends ConsumerWidget {
  const AppCheckbox({
    super.key,
    this.size = 20,
    this.state = AppCheckboxState.unchecked,
    this.onChanged,
    this.padding = EdgeInsets.zero,
  });

  final double size;
  final AppCheckboxState state;
  final AppCheckboxChangedCallback? onChanged;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _primitiveColors = ref.watch(primitiveTokensProvider);

    final _isUnchecked = state == AppCheckboxState.unchecked;
    final _isIntermediate = state == AppCheckboxState.intermediate;
    final _isChecked = state == AppCheckboxState.checked;

    final _checkboxTheme = _isChecked
        ? _colors.selectedCheckbox
        : _isIntermediate
            ? _colors.intermediateCheckbox
            : _colors.unselectedCheckbox;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final _newState = state == AppCheckboxState.checked
            ? AppCheckboxState.unchecked
            : AppCheckboxState.checked;

        onChanged?.call(_newState);
      },
      onLongPress: () {
        if (state != AppCheckboxState.unchecked) return;

        onChanged?.call(AppCheckboxState.intermediate);
      },
      child: Padding(
        padding: padding,
        child: Container(
          width: size,
          height: size,
          decoration: ShapeDecoration(
            color: _isUnchecked ? null : _checkboxTheme.background,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 6, cornerSmoothing: 1),
              side: BorderSide(
                color: _checkboxTheme.border,
              ),
            ),
          ),
          child: _isChecked
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.check,
                      colorFilter: ColorFilter.mode(
                        _primitiveColors.neutral.shade100,
                        BlendMode.srcIn,
                      ),
                    ),
                    // Slightly offset duplicate to create bold effect
                    Transform.translate(
                      offset: const Offset(0.4, 0.4),
                      child: SvgPicture.asset(
                        Assets.check,
                        colorFilter: ColorFilter.mode(
                          _primitiveColors.neutral.shade100,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                )
              : _isIntermediate
                  ? Center(
                      child: Container(
                        height: 2.5,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: ShapeDecoration(
                          color: _primitiveColors.neutral.shade100,
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(cornerRadius: 4, cornerSmoothing: 1),
                          ),
                        ),
                      ),
                    )
                  : null,
        ),
      ),
    );
  }
}
