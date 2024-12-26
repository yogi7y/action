// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../../design_system/typography/typography.dart';
import '../../../../shared/sticky_component_over_keyboard/sticky_keyboard_provider.dart';
import '../../../tasks/presentation/state/new_task_provider.dart';
import '../../domain/entity/project.dart';

class ProjectPickerTileRenderer extends SearchRenderer<ProjectEntity> {
  ProjectPickerTileRenderer({
    required this.fonts,
  });

  final Fonts fonts;

  @override
  Widget render(BuildContext context, ProjectEntity item) {
    return Text(
      item.stringifiedValue,
      style: fonts.text.sm.medium,
    );
  }

  @override
  void onItemSelected(BuildContext context, ProjectEntity item) {
    final _container = ProviderScope.containerOf(context);
    _container.read(newTaskProvider.notifier).focusNode.requestFocus();
    _container.read(currentStickyTextFieldTypeProvider.notifier).update((_) => null);

    _container.read(newTaskProvider.notifier).updateValue(projectId: item.id);
  }
}
