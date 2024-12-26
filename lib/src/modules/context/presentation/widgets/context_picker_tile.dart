import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../../design_system/typography/typography.dart';
import '../../../../shared/sticky_component_over_keyboard/sticky_keyboard_provider.dart';
import '../../../tasks/presentation/state/new_task_provider.dart';
import '../../domain/entity/context.dart';

class ContextPickerTileRenderer extends SearchRenderer<ContextEntity> {
  ContextPickerTileRenderer({
    required this.fonts,
  });

  final Fonts fonts;

  @override
  Widget render(BuildContext context, ContextEntity item) {
    return Text(
      item.stringifiedValue,
      style: fonts.text.sm.medium,
    );
  }

  @override
  void onItemSelected(BuildContext context, ContextEntity item) {
    final _container = ProviderScope.containerOf(context);
    _container.read(newTaskProvider.notifier).focusNode.requestFocus();
    _container.read(currentStickyTextFieldTypeProvider.notifier).update((_) => null);

    _container.read(newTaskProvider.notifier).updateValue(contextId: item.id);
  }
}
