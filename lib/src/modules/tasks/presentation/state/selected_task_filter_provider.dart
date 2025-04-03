import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_list_view_data_provider.dart';

/// Selected task filter state for the filters in the main task screen.
final selectedTaskFilterProvider =
    StateProvider<String>((ref) => ref.read(taskScreenTaskViewsProvider).first.name);
