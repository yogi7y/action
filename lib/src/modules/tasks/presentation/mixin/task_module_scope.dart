import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/task_module.dart';
import '../state/filter_keys_provider.dart';
import '../state/new_task_provider.dart';
import '../state/task_view_provider.dart';

mixin TaskModuleScope {
  List<Override> createTaskModuleScope(TaskModuleData data) => [
        taskModelDataProvider.overrideWithValue(data),
        filterKeysProvider.overrideWith(FilterKeysNotifier.new),
        taskViewProvider.overrideWithValue(data.taskViews),
        selectedTaskViewProvider.overrideWith(SelectedTaskView.new),
        newTaskProvider.overrideWith(NewTaskTextNotifier.new),
        tasksPageControllerProvider.overrideWithValue(PageController()),
      ];
}
