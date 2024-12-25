import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/buttons/icon_button.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../../domain/entity/task.dart';
import '../state/new_task_provider.dart';
import '../state/tasks_provider.dart';

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
          child: Opacity(
            opacity: _opacity.value,
            child: child,
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

class _TaskInputFieldState extends ConsumerState<TaskInputField> {
  late final _controller = ref.watch(newTaskTextProvider.notifier).controller;
  late final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleTextFieldFocus();
    });
  }

  void _handleTextFieldFocus() {
    ref.listenManual(isTaskTextInputFieldVisibleProvider, (previous, next) {
      if (next) {
        focusNode.requestFocus();
      } else {
        focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTappedOutside(PointerDownEvent? event) {}

  @override
  Widget build(BuildContext context) {
    final _spacing = ref.watch(spacingProvider);
    final _fonts = ref.watch(fontsProvider);
    final _colors = ref.watch(appThemeProvider);

    final _style = _fonts.text.md.regular.copyWith(
      color: _colors.textTokens.primary,
      fontSize: 15,
      fontVariations: [
        const FontVariation.weight(450),
      ],
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: _spacing.lg),
      child: Row(
        children: [
          const AppCheckbox(),
          SizedBox(width: _spacing.xs),
          Expanded(
            child: SmartTextField(
              controller: _controller,
              textFormFieldBuilder: (context, controller) {
                return TextFormField(
                  focusNode: focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  style: _style,
                  onTapOutside: _onTappedOutside,
                  controller: controller,
                  cursorColor: _colors.textTokens.secondary,
                  cursorOpacityAnimates: true,
                  cursorHeight: 22,
                  decoration: InputDecoration(
                    hintText: 'Use @ to pick projects, # to pick tags',
                    border: InputBorder.none,
                    hintStyle: _fonts.text.sm.regular.copyWith(
                      color: _colors.textTokens.secondary,
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    suffixIcon: const SendIcon(),
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

class SendIcon extends ConsumerWidget {
  const SendIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _newTaskText = ref.watch(newTaskTextProvider);
    final _colors = ref.watch(appThemeProvider);

    final _iconColor = _newTaskText.isEmpty ? _colors.textTokens.secondary : _colors.primary;

    return Consumer(
      builder: (context, ref, _) {
        return UnconstrainedBox(
          child: AppIconButton(
            svgIconPath: Assets.send,
            size: 24,
            color: _iconColor,
            onClick: () async => _addTask(ref: ref),
          ),
        );
      },
    );
  }

  Future<void> _addTask({
    required WidgetRef ref,
  }) async {
    final _taskNotifier = ref.watch(tasksProvider.notifier);
    final _taskName = ref.watch(newTaskTextProvider);

    final _taskProperties = TaskPropertiesEntity(
      name: _taskName,
      status: TaskStatus.todo,
    );

    await _taskNotifier.addTask(_taskProperties);
  }
}
