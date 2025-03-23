import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/design_system.dart';
import '../../design_system/icons/app_icons.dart';
import '../../modules/dashboard/presentation/state/keyboard_visibility_provider.dart';

class CommonPicker extends ConsumerStatefulWidget {
  const CommonPicker({
    required this.controller,
    required this.title,
    required this.itemBuilder,
    required this.emptyStateWidget,
    required this.syncTextController,
    required this.items,
    super.key,
  });

  final OverlayPortalController controller;
  final String title;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget emptyStateWidget;
  final Function(TextEditingController controller, WidgetRef ref) syncTextController;
  final List<dynamic> items;

  @override
  ConsumerState<CommonPicker> createState() => _CommonPickerState();
}

class _CommonPickerState extends ConsumerState<CommonPicker> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Sync text controller with the query provider
      widget.syncTextController(_textController, ref);
      _overlayAndKeyboardVisibilitySync();
    });
  }

  /// sync overlay's visibility with keyboard's visibility
  /// should be shown when keyboard is shown
  /// should be hidden when keyboard is hidden
  void _overlayAndKeyboardVisibilitySync() {
    ref.listenManual(
      keyboardVisibilityProvider,
      (_, next) {
        final nextValue = next.valueOrNull ?? false;

        if (!nextValue) widget.controller.hide();
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ref.watch(spacingProvider);

    return Stack(
      children: [
        // Invisible overlay to detect taps outside
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.controller.hide(),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        // Picker UI
        AnimatedPositioned(
          duration: defaultAnimationDuration,
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Results card
              _ResultContainer(
                itemBuilder: widget.itemBuilder,
                emptyStateWidget: widget.emptyStateWidget,
                items: widget.items,
              ),

              // Small spacing
              SizedBox(height: spacing.sm),

              // Search field at the bottom
              _PickerTextField(
                textController: _textController,
                focusNode: _focusNode,
                hintText: widget.title,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultContainer extends ConsumerWidget {
  const _ResultContainer({
    required this.itemBuilder,
    required this.emptyStateWidget,
    required this.items,
  });

  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget emptyStateWidget;
  final List<dynamic> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final spacing = ref.watch(spacingProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing.md),
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.35,
      ),
      decoration: ShapeDecoration(
        color: colors.overlay.background,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: 16, cornerSmoothing: 1),
          side: BorderSide(color: colors.overlay.borderStroke),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: items.isEmpty
          ? emptyStateWidget
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: itemBuilder,
            ),
    );
  }
}

class _PickerTextField extends ConsumerWidget {
  const _PickerTextField({
    required TextEditingController textController,
    required FocusNode focusNode,
    required this.hintText,
  })  : _textController = textController,
        _focusNode = focusNode;

  final TextEditingController _textController;
  final FocusNode _focusNode;
  final String hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);
    final spacing = ref.watch(spacingProvider);

    return GestureDetector(
      // Prevent taps on TextField from closing the overlay
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.sm),
        child: TextField(
          autofocus: true,
          controller: _textController,
          focusNode: _focusNode,
          style: fonts.text.md.regular.copyWith(
            color: colors.textTokens.primary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: fonts.text.md.regular.copyWith(
              color: colors.textTokens.secondary,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                AppIcons.search,
                size: 20,
                color: colors.textTokens.secondary,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.overlay.borderStroke,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.overlay.borderStroke,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.overlay.borderStroke,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            filled: true,
            fillColor: colors.surface.backgroundContrast,
          ),
        ),
      ),
    );
  }
}
