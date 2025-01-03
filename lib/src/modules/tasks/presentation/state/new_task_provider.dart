import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../domain/entity/task.dart';
import 'task_filter_provider.dart';

final isTaskTextInputFieldVisibleProvider = StateProvider<bool>((ref) => false);

/// holds the task entered by the user.
final newTaskProvider =
    AutoDisposeNotifierProvider<NewTaskTextNotifier, TaskPropertiesEntity>(NewTaskTextNotifier.new);

class NewTaskTextNotifier extends AutoDisposeNotifier<TaskPropertiesEntity> {
  late final controller = SmartTextFieldController();
  late final focusNode = FocusNode();

  @override
  TaskPropertiesEntity build() {
    _syncControllerAndState();
    final _selectedTaskView = ref.read(selectedTaskFilterProvider);

    final _task = TaskPropertiesEntity(
      name: '',
      status: _selectedTaskView.status,
    );

    return _task;
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
