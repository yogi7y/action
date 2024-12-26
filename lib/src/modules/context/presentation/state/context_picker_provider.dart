// lib/src/modules/context/presentation/state/context_picker_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../../design_system/design_system.dart';
import '../../domain/entity/context.dart';
import '../widgets/context_picker_tile.dart';
import 'context_provider.dart';

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
