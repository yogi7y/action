import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../filter/domain/entity/composite/composite_filter.dart';
import '../../../filter/domain/entity/filter.dart';
import '../../domain/entity/filters/task_filter_operations.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/entity/task_status.dart';
import 'task_view_provider.old.dart';

/// Decides when to show/hide the task input field.
final isTaskTextInputFieldVisibleProvider = StateProvider<bool>((ref) => false);

/// holds the task entered by the user.
final newTaskProvider = AutoDisposeNotifierProvider<NewTaskTextNotifier, TaskEntity>(
  name: 'newTaskProvider',
  () => throw UnimplementedError('Ensure to override newTaskProvider with a value'),
);

class NewTaskTextNotifier extends AutoDisposeNotifier<TaskEntity> {
  late final controller = SmartTextFieldController();
  late final focusNode = FocusNode();

  @override
  TaskEntity build() {
    _syncControllerAndState();

    final filter = ref.read(selectedTaskViewProvider).operations.filter;

    var task = const TaskEntity(
      name: '',
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

  TaskEntity getFilterValue(PropertyFilter filter, TaskEntity task) {
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

  void updateValue(TaskEntity Function(TaskEntity) update) => state = update(state);

  @Deprecated('Use updateValue instead')
  void updateValueOld({
    String? name,
    TaskStatus? status,
    DateTime? dueDate,
    String? projectId,
    String? contextId,
    String? id,
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
