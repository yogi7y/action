import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task_entity.dart';
import 'task_view_provider.old.dart';

mixin InMemoryTaskMixin {
  /// Manages the task in memory. This means it decides if the task should be added or removed or updated
  /// based on the loaded task views.
  /// Iterate over the loaded task views, check if a task belongs, then add, remove or update it.
  /// If a certain view is present, but not loaded in memory we'll not take any actions on it, because
  /// when the user navigates to that view, the task will be loaded automatically by the API.
  void handleInMemoryTask(TaskEntity task, WidgetRef ref) {
    final loadedTaskViews = ref.read(loadedTaskViewsProvider);
  }
}
