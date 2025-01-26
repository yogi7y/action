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
import '../../modules/context/presentation/state/context_picker_provider.dart';
import '../../modules/projects/presentation/state/project_picker_provider.dart';
import '../buttons/icon_button.dart';
import 'sticky_keyboard_provider.dart';

class StickyTextField extends ConsumerWidget {
  const StickyTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sources = ref.watch(stickyTextFieldSourcesProvider);
    final spacing = ref.watch(spacingProvider);
    final colors = ref.watch(appThemeProvider);
    final fonts = ref.watch(fontsProvider);

    final isProjectVisible =
        ref.watch(currentStickyTextFieldTypeProvider) == StickyTextFieldType.project;

    final hintText = isProjectVisible ? 'Select Project' : 'Select Context';

    return SearchableDropdownField(
      sources: sources,
      requestFocusOnCreated: true,
      searchableDropdownFieldData: SearchableDropdownFieldData(
        padding: EdgeInsets.all(spacing.md),
        margin: const EdgeInsets.only(bottom: 16),
        verticalSpacing: spacing.md,
        inputFieldDecoration: SearchableInputFieldDecoration(
          hintText: hintText,
          hintTextStyle: fonts.text.md.medium.copyWith(
            color: colors.textTokens.secondary,
          ),
          prefix: _PrefixIcon(),
        ),
        overlayDecoration: ShapeDecoration(
          color: colors.surface.backgroundContrast,
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
    final currentTheme = ref.watch(appThemeProvider);
    final primitiveTokens = ref.watch(primitiveTokensProvider);

    final lightShadow = [
      BoxShadow(
        color: primitiveTokens.neutral.shade500.withValues(alpha: .15),
        blurRadius: 6,
        spreadRadius: 4,
        offset: const Offset(0, 6),
      ),
    ];

    final darkShadow = [
      BoxShadow(
        color: primitiveTokens.dark.withValues(alpha: .2),
        blurRadius: 6,
        spreadRadius: 4,
        offset: const Offset(0, 6),
      ),
    ];

    return currentTheme is DarkTheme ? darkShadow : lightShadow;
  }
}

class _PrefixIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appThemeProvider);
    final isStickyTextFieldVisible = ref.watch(currentStickyTextFieldTypeProvider) != null;

    final icon = isStickyTextFieldVisible ? Assets.arrowBack : Assets.arrowBack;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(currentStickyTextFieldTypeProvider.notifier).update((_) => null);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: AppIconButton(
          svgIconPath: icon,
          color: colors.textTokens.secondary,
        ),
      ),
    );
  }
}

final stickyTextFieldSourcesProvider = Provider<List<SearchSource>>((ref) {
  final sources = <SearchSource>[];
  final currentStickyTextFieldType = ref.watch(currentStickyTextFieldTypeProvider);

  final isProjectTextFieldVisible = currentStickyTextFieldType == StickyTextFieldType.project;
  final isContextTextFieldVisible = currentStickyTextFieldType == StickyTextFieldType.context;

  if (isProjectTextFieldVisible) {
    sources.add(ref.watch(projectPickerSearchSourceProvider));
  } else if (isContextTextFieldVisible) {
    sources.add(ref.watch(contextPickerSearchSourceProvider));
  }

  return sources;
});
