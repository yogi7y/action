import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../filter/domain/entity/composite/composite_filter.dart';
import '../../../filter/domain/entity/filter.dart';
import '../../domain/entity/filters/task_filter_operations.dart';
import '../../domain/entity/task.dart';
import '../../domain/entity/task_status.dart';
import 'task_filter_provider.dart';

/// Decides when to show/hide the task input field.
final isTaskTextInputFieldVisibleProvider = StateProvider<bool>((ref) => false);

/// holds the task entered by the user.
final newTaskProvider = AutoDisposeNotifierProvider<NewTaskTextNotifier, TaskPropertiesEntity>(
  NewTaskTextNotifier.new,
);

class NewTaskTextNotifier extends AutoDisposeNotifier<TaskPropertiesEntity> {
  late final controller = SmartTextFieldController();
  late final focusNode = FocusNode();

  @override
  TaskPropertiesEntity build() {
    _syncControllerAndState();

    final filter = ref.read(selectedTaskViewProvider).operations.filter;

    var task = const TaskPropertiesEntity(
      name: '',
      status: TaskStatus.todo,
    );

    if (filter is PropertyFilter) {
      task = getFilterValue(filter, task);
    }

    if (filter is CompositeFilter) {
      for (final child in filter.filters) {
        if (child is PropertyFilter) {
          task = getFilterValue(child, task);
        }
      }
    }

    return task;
  }

  TaskPropertiesEntity getFilterValue(PropertyFilter filter, TaskPropertiesEntity task) {
    final key = filter.key;
    final value = filter.value;

    var returnTask = task;

    switch (key) {
      case InMemoryTaskFilterOperations.statusKey:
        final status = TaskStatus.fromString(value as String);
        returnTask = returnTask.copyWith(status: status);
      default:
        return returnTask;
    }

    return returnTask;
  }

  void _syncControllerAndState() =>
      controller.addListener(() => state = state.copyWith(name: controller.text));

  void clear() => controller.clear();

  void updateValue({
    String? name,
    TaskStatus? status,
    DateTime? dueDate,
    String? projectId,
    String? contextId,
  }) =>
      state = state.copyWith(
        name: name ?? state.name,
        status: status ?? state.status,
        dueDate: dueDate ?? state.dueDate,
        projectId: projectId ?? state.projectId,
        contextId: contextId ?? state.contextId,
      );

  void mark({
    bool dueDateAsNull = false,
    bool projectIdAsNull = false,
    bool contextIdAsNull = false,
  }) =>
      state = state.mark(
        dueDateAsNull: dueDateAsNull,
        projectIdAsNull: projectIdAsNull,
        contextIdAsNull: contextIdAsNull,
      );
}
