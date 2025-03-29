import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/buttons/send_icon.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../mixin/task_ui_triggers.dart';
import '../state/new_task_provider.dart';

class TaskInputFieldVisibility extends ConsumerStatefulWidget {
  const TaskInputFieldVisibility({super.key});

  @override
  ConsumerState<TaskInputFieldVisibility> createState() => _TaskInputFieldVisibilityState();
}

class _TaskInputFieldVisibilityState extends ConsumerState<TaskInputFieldVisibility>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;
  late final Animation<double> _opacity;

  static const _duration = defaultAnimationDuration;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _duration,
      vsync: this,
    );

    _heightFactor = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutSine,
    ));

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    ref.listenManual(isTaskTextInputFieldVisibleProvider, (previous, next) {
      if (next) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => ClipRect(
        child: Align(
          heightFactor: _heightFactor.value,
          child: Visibility(
            visible: _heightFactor.value > 0,
            child: Opacity(
              opacity: _opacity.value,
              child: child,
            ),
          ),
        ),
      ),
      child: const TaskInputField(),
    );
  }
}

@immutable
class TaskInputField extends ConsumerStatefulWidget {
  const TaskInputField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends ConsumerState<TaskInputField> with TaskUiTriggersMixin {
  late final _controller = ref.watch(newTaskProvider.notifier).controller;
  late final focusNode = ref.watch(newTaskProvider.notifier).focusNode;
  late final _keyboardListenerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleTextFieldFocus();
      _controller.addListener(_onTextChanged);
    });
  }

  void _handleTextFieldFocus() {
    if (ref.read(isTaskTextInputFieldVisibleProvider)) focusNode.requestFocus();

    ref.listenManual(isTaskTextInputFieldVisibleProvider, (previous, next) {
      if (next) {
        focusNode.requestFocus();
      } else {
        focusNode.unfocus();
      }
    });
  }

  void _onTextChanged() {
    final dateTime = _controller.highlightedDateTime;

    final existingDateTime = ref.read(newTaskProvider);

    if (dateTime?.millisecondsSinceEpoch == existingDateTime.dueDate?.millisecondsSinceEpoch)
      return;

    if (dateTime == null) {
      ref.read(newTaskProvider.notifier).mark(dueDateAsNull: true);
      return;
    }

    ref.read(newTaskProvider.notifier).updateValue((state) => state.copyWith(dueDate: dateTime));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ref.watch(spacingProvider);
    final fonts = ref.watch(fontsProvider);
    final colors = ref.watch(appThemeProvider);

    final style = fonts.text.md.regular.copyWith(
      color: colors.textTokens.primary,
      fontSize: 15,
      fontVariations: [
        const FontVariation.weight(450),
      ],
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(0, 2),
            child: const AppCheckbox(),
          ),
          SizedBox(width: spacing.xs),
          Expanded(
            child: SmartTextField(
              controller: _controller,
              textFormFieldBuilder: (context, controller) {
                return KeyboardListener(
                  focusNode: _keyboardListenerFocusNode,
                  onKeyEvent: (event) {
                    if (controller.text.isNotEmpty) return;

                    // when backspace is pressed on an empty text field, remove the field.
                    if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      if (controller.text.isEmpty) {
                        _keyboardListenerFocusNode.unfocus();
                        ref
                            .read(isTaskTextInputFieldVisibleProvider.notifier)
                            .update((state) => false);
                        unawaited(HapticFeedback.lightImpact());
                      }
                    }
                  },
                  child: TextFormField(
                    focusNode: focusNode,
                    minLines: 1,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) async {
                      if (value.trim().isEmpty) return;

                      focusNode.requestFocus();
                      return addTask(ref: ref);
                    },
                    style: style,
                    controller: controller,
                    cursorColor: colors.textTokens.secondary,
                    cursorOpacityAnimates: true,
                    cursorHeight: 22,
                    decoration: InputDecoration(
                      hintText: 'Use @ to pick projects, # to pick tags',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintStyle: fonts.text.sm.regular.copyWith(
                        color: colors.textTokens.secondary,
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      suffixIcon: const _TaskSendIcon(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskSendIcon extends ConsumerWidget with TaskUiTriggersMixin {
  const _TaskSendIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newTaskText = ref.watch(newTaskProvider.select((value) => value.name.trim()));

    return SendIcon(
      onClick: () async => addTask(ref: ref),
      isEnabled: newTaskText.isNotEmpty,
    );
  }
}
