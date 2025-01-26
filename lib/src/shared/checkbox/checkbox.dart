import 'dart:async';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../design_system/design_system.dart';
import '../../modules/projects/domain/entity/project_status.dart';
import '../../modules/tasks/domain/entity/task_status.dart';
import '../../services/audio/audio_service.dart';

typedef AppCheckboxChangedCallback = void Function(AppCheckboxState state);

/// Represents the state of a checkbox in the application.
///
/// Can be in one of three states:
/// - [unchecked]: The default state, indicating no selection
/// - [intermediate]: A partial or in-progress state
/// - [checked]: The fully selected state
enum AppCheckboxState {
  /// The default unselected state
  unchecked(),

  /// Represents a partial or in-progress state
  intermediate(),

  /// The fully selected state
  checked();

  const AppCheckboxState();

  /// Creates an [AppCheckboxState] from a boolean value.
  ///
  /// [value] determines if the state should be checked (true) or unchecked (false).
  /// Defaults to false if not specified.
  factory AppCheckboxState.fromBool({bool value = false}) =>
      value ? AppCheckboxState.checked : AppCheckboxState.unchecked;

  /// Creates an [AppCheckboxState] from a [TaskStatus].
  ///
  /// Maps the task status to the appropriate checkbox state using the
  /// [TaskStatus.toAppCheckboxState] extension method.
  factory AppCheckboxState.fromTaskStatus({required TaskStatus status}) =>
      status.toAppCheckboxState();

  // /// Creates an [AppCheckboxState] from a [ProjectStatus].
  // ///
  // /// Maps the project status to the appropriate checkbox state using the
  // /// [ProjectStatus.toAppCheckboxState] extension method.
  // factory AppCheckboxState.fromProjectStatus({required ProjectStatus status}) =>
  //     status.toAppCheckboxState();

  /// Converts the [AppCheckboxState] to a [ProjectStatus].
  ///
  /// Maps:
  /// - [checked] to [ProjectStatus.done]
  /// - [intermediate] to [ProjectStatus.inProgress]
  /// - [unchecked] to [ProjectStatus.notStarted]
  ProjectStatus toProjectStatus() {
    switch (this) {
      case AppCheckboxState.checked:
        return ProjectStatus.done;

      case AppCheckboxState.intermediate:
        return ProjectStatus.inProgress;

      case AppCheckboxState.unchecked:
        return ProjectStatus.notStarted;
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
    final colors = ref.watch(appThemeProvider);
    final primitiveColors = ref.watch(primitiveTokensProvider);

    final isUnchecked = state == AppCheckboxState.unchecked;
    final isIntermediate = state == AppCheckboxState.intermediate;
    final isChecked = state == AppCheckboxState.checked;

    final checkboxTheme = isChecked
        ? colors.selectedCheckbox
        : isIntermediate
            ? colors.intermediateCheckbox
            : colors.unselectedCheckbox;

    final audioService = ref.watch(audioServiceProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final newState = state == AppCheckboxState.checked
            ? AppCheckboxState.unchecked
            : AppCheckboxState.checked;

        unawaited(HapticFeedback.lightImpact());

        if (newState == AppCheckboxState.unchecked) {
          unawaited(audioService.playAudio(AssetsV2.whoosh));
        } else {
          unawaited(audioService.playAudio(AssetsV2.bubbleBurst1));
        }

        onChanged?.call(newState);
      },
      onLongPress: () {
        unawaited(HapticFeedback.lightImpact());
        if (state != AppCheckboxState.unchecked) return;

        onChanged?.call(AppCheckboxState.intermediate);
      },
      child: Padding(
        padding: padding,
        child: Container(
          width: size,
          height: size,
          decoration: ShapeDecoration(
            color: isUnchecked ? null : checkboxTheme.background,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 6, cornerSmoothing: 1),
              side: BorderSide(
                color: checkboxTheme.border,
              ),
            ),
          ),
          child: isChecked
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.check,
                      colorFilter: ColorFilter.mode(
                        primitiveColors.neutral.shade100,
                        BlendMode.srcIn,
                      ),
                    ),
                    // Slightly offset duplicate to create bold effect
                    Transform.translate(
                      offset: const Offset(0.4, 0.4),
                      child: SvgPicture.asset(
                        Assets.check,
                        colorFilter: ColorFilter.mode(
                          primitiveColors.neutral.shade100,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                )
              : isIntermediate
                  ? Center(
                      child: Container(
                        height: 2.5,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: ShapeDecoration(
                          color: primitiveColors.neutral.shade100,
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
