import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../shared/buttons/send_icon.dart';
import '../../../../shared/checkbox/checkbox.dart';
import '../mixin/checklist_operations_mixin.dart';
import '../state/new_checklist_provider.dart';

class ChecklistInputVisibility extends ConsumerStatefulWidget {
  const ChecklistInputVisibility({super.key});

  @override
  ConsumerState<ChecklistInputVisibility> createState() => _ChecklistInputVisibilityState();
}

class _ChecklistInputVisibilityState extends ConsumerState<ChecklistInputVisibility>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: defaultAnimationDuration,
      vsync: this,
    );

    _heightFactor = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutSine),
    );

    ref.listenManual(isChecklistTextInputFieldVisibleProvider, (previous, next) {
      if (next) {
        ref.read(newChecklistProvider.notifier).focusNode.requestFocus();
        _controller.forward();
      } else {
        ref.read(newChecklistProvider.notifier).focusNode.unfocus();
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
          child: child,
        ),
      ),
      child: const ChecklistInput(),
    );
  }
}

class ChecklistInput extends ConsumerStatefulWidget {
  const ChecklistInput({super.key});

  @override
  ConsumerState<ChecklistInput> createState() => _ChecklistInputState();
}

class _ChecklistInputState extends ConsumerState<ChecklistInput> with ChecklistUiTriggerMixin {
  late final _textController = ref.read(newChecklistProvider.notifier).controller;

  @override
  Widget build(BuildContext context) {
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);
    final _spacing = ref.watch(spacingProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(0, 2),
          child: AppCheckbox(
            padding: EdgeInsets.only(right: _spacing.xs),
          ),
        ),
        Expanded(
          child: TextField(
            controller: _textController,
            minLines: 1,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            focusNode: ref.watch(newChecklistProvider.notifier).focusNode,
            style: _fonts.text.md.regular.copyWith(
              color: _colors.textTokens.primary,
            ),
            decoration: InputDecoration(
              hintText: 'Add checklist item',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintStyle: _fonts.text.md.regular.copyWith(
                color: _colors.textTokens.secondary.withValues(alpha: .8),
              ),
              suffixIcon: const _ChecklistSendIcon(),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
            onSubmitted: (value) async {
              if (value.isEmpty) return;

              ref.read(newChecklistProvider.notifier).focusNode.requestFocus();

              await addChecklist(
                ref: ref,
                checklistText: _textController.text,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChecklistSendIcon extends ConsumerWidget with ChecklistUiTriggerMixin {
  const _ChecklistSendIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _title = ref.watch(newChecklistProvider.select((value) => value.title.trim()));

    return SendIcon(
      onClick: () async => addChecklist(
        ref: ref,
        checklistText: _title,
      ),
      isEnabled: _title.isNotEmpty,
    );
  }
}
