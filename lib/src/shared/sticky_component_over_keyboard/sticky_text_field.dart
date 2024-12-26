import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../design_system/assets/assets_constants.dart';
import '../../design_system/colors/primitive_tokens.dart';
import '../../design_system/spacing/spacing.dart';
import '../../design_system/themes/base/theme.dart';
import '../../design_system/themes/dark/dark_theme.dart';
import '../../design_system/typography/typography.dart';
import '../../modules/projects/presentation/state/project_picker_provider.dart';
import '../buttons/icon_button.dart';
import 'sticky_keyboard_provider.dart';

class StickyTextField extends ConsumerWidget {
  const StickyTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _sources = ref.watch(stickyTextFieldSourcesProvider);
    final _spacing = ref.watch(spacingProvider);
    final _colors = ref.watch(appThemeProvider);
    final _fonts = ref.watch(fontsProvider);

    final _isProjectVisible =
        ref.watch(currentStickyTextFieldTypeProvider) == StickyTextFieldType.project;

    final _hintText = _isProjectVisible ? 'Select Project' : 'Select Context';

    return SearchableDropdownField(
      sources: _sources,
      requestFocusOnCreated: true,
      searchableDropdownFieldData: SearchableDropdownFieldData(
        padding: EdgeInsets.all(_spacing.md),
        margin: const EdgeInsets.only(bottom: 16),
        verticalSpacing: _spacing.md,
        inputFieldDecoration: SearchableInputFieldDecoration(
          hintText: _hintText,
          hintTextStyle: _fonts.text.md.medium.copyWith(
            color: _colors.textTokens.secondary,
          ),
          prefix: _PrefixIcon(),
        ),
        overlayDecoration: ShapeDecoration(
          color: _colors.surface.backgroundContrast,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 12),
          ),
          shadows: _getShadows(ref: ref),
        ),
      ),
    );
  }

  List<BoxShadow> _getShadows({
    required WidgetRef ref,
  }) {
    final _currentTheme = ref.watch(appThemeProvider);
    final _primitiveTokens = ref.watch(primitiveTokensProvider);

    final _lightShadow = [
      BoxShadow(
        color: _primitiveTokens.neutral.shade500.withValues(alpha: .15),
        blurRadius: 6,
        spreadRadius: 4,
        offset: const Offset(0, 6),
      ),
    ];

    final _darkShadow = [
      BoxShadow(
        color: _primitiveTokens.dark.withValues(alpha: .2),
        blurRadius: 6,
        spreadRadius: 4,
        offset: const Offset(0, 6),
      ),
    ];

    return _currentTheme is DarkTheme ? _darkShadow : _lightShadow;
  }
}

class _PrefixIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colors = ref.watch(appThemeProvider);
    final _isStickyTextFieldVisible = ref.watch(currentStickyTextFieldTypeProvider) != null;

    final _icon = _isStickyTextFieldVisible ? Assets.arrowBack : Assets.arrowBack;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(currentStickyTextFieldTypeProvider.notifier).update((_) => null);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: AppIconButton(
          svgIconPath: _icon,
          color: _colors.textTokens.secondary,
        ),
      ),
    );
  }
}

final stickyTextFieldSourcesProvider = Provider<List<SearchSource>>((ref) {
  final _sources = <SearchSource>[];

  final _currentStickyTextFieldType = ref.watch(currentStickyTextFieldTypeProvider);

  final _isProjectTextFieldVisible = _currentStickyTextFieldType == StickyTextFieldType.project;

  if (_isProjectTextFieldVisible) {
    _sources.add(ref.watch(projectPickerSearchSourceProvider));
  }

  return _sources;
});
