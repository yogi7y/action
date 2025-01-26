import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

class ProjectPickerSearchSyncProvider extends SyncSearchProvider {
  ProjectPickerSearchSyncProvider({required super.items});

  @override
  bool query({required Query text, required Searchable item}) =>
      item.stringifiedValue.toLowerCase().contains(
            text.toLowerCase(),
          );
}

final projectPickerSearchSourceProvider = Provider<SearchSource>((ref) {
  throw UnimplementedError();
});
