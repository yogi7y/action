import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../modules/projects/presentation/state/project_picker_provider.dart';
import 'sticky_keyboard_provider.dart';

class StickyTextField extends ConsumerWidget {
  const StickyTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _sources = ref.watch(stickyTextFieldSourcesProvider);

    return SearchableDropdownField(sources: _sources);
  }
}

final stickyTextFieldSourcesProvider = Provider<List<SearchSource>>((ref) {
  final _sources = <SearchSource>[];

  final _isProjectTextFieldVisible = ref.watch(showProjectStickyTextFieldProvider);

  if (_isProjectTextFieldVisible) {
    _sources.add(ref.watch(projectPickerSearchSourceProvider));
  }

  return _sources;
});
