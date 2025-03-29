// lib/src/modules/context/presentation/state/context_picker_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../../design_system/design_system.dart';
import '../../domain/entity/context.dart';
import '../widgets/context_picker_tile.dart';
import 'context_provider.dart';
import '../view_models/context_view_model.dart';

class ContextPickerSearchSyncProvider extends SyncSearchProvider<ContextEntity> {
  ContextPickerSearchSyncProvider({required super.items});

  @override
  bool query({required Query text, required Searchable item}) =>
      item.stringifiedValue.toLowerCase().contains(
            text.toLowerCase(),
          );
}

final contextPickerSearchSourceProvider = Provider<SearchSource>((ref) {
  final _contexts = ref.watch(contextsProvider).valueOrNull ?? [];
  final _fonts = ref.watch(fontsProvider);

  return SearchSource(
    provider: ContextPickerSearchSyncProvider(items: _contexts),
    renderer: ContextPickerTileRenderer(fonts: _fonts),
  );
});

/// Provider to hold the current search query for context picker
final contextPickerQueryProvider = StateProvider<String>((ref) => '');

/// Provider to filter contexts based on the search query
final contextPickerResultsProvider = Provider.family<List<ContextViewModel>, String>((ref, query) {
  final contextsAsync = ref.watch(contextsProvider);

  // Return all contexts when loaded, empty list otherwise
  final allContexts = contextsAsync.valueOrNull ?? [];

  // Convert ContextEntity to ContextViewModel
  final contextViewModels =
      allContexts.map((context) => ContextViewModel(context: context)).toList();

  // If query is empty, return all contexts
  if (query.isEmpty) return contextViewModels;

  // Filter contexts based on query
  return contextViewModels
      .where((contextViewModel) =>
          contextViewModel.context.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
});

/// Utility extension to sync TextEditingController with contextPickerQueryProvider
extension ContextPickerTextControllerSync on TextEditingController {
  void syncWithContextPickerQuery(WidgetRef ref) {
    // Listen to changes from the text controller and update the provider
    addListener(() {
      ref.read(contextPickerQueryProvider.notifier).state = text;
    });
  }
}

/// Provider to hold the currently selected context in the picker
final selectedContextPickerProvider = StateProvider<ContextViewModel?>((ref) => null);

final contextPickerDataProvider = Provider<ContextPickerData>(
  (ref) => throw UnimplementedError('Ensure to override contextPickerDataProvider'),
  name: 'contextPickerDataProvider',
);

@immutable
class ContextPickerData {
  const ContextPickerData({
    required this.onContextSelected,
    this.selectedContext,
    this.onRemove,
  });

  /// Called when a context is selected.
  final void Function(ContextViewModel viewModel) onContextSelected;

  /// Called when a context is removed.
  final void Function(ContextViewModel viewModel)? onRemove;

  /// Selected context.
  final ContextViewModel? selectedContext;

  @override
  String toString() => 'ContextPickerData(onContextSelected: $onContextSelected)';

  @override
  bool operator ==(covariant ContextPickerData other) {
    if (identical(this, other)) return true;

    return other.onContextSelected == onContextSelected;
  }

  @override
  int get hashCode => onContextSelected.hashCode;
}
