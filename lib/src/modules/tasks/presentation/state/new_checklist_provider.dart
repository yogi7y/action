import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/checklist.dart';

final isChecklistTextInputFieldVisibleProvider = StateProvider<bool>((ref) => false);

final newChecklistProvider =
    AutoDisposeNotifierProvider<NewChecklistTextNotifier, ChecklistPropertiesEntity>(
        NewChecklistTextNotifier.new);

class NewChecklistTextNotifier extends AutoDisposeNotifier<ChecklistPropertiesEntity> {
  late final controller = TextEditingController();
  late final focusNode = FocusNode();

  @override
  ChecklistPropertiesEntity build() {
    _syncControllerAndState();

    ref.onDispose(() {
      controller.dispose();
      focusNode.dispose();
    });

    return const ChecklistPropertiesEntity(
      taskId: '',
      title: '',
      status: ChecklistStatus.todo,
    );
  }

  void _syncControllerAndState() =>
      controller.addListener(() => state = state.copyWith(title: controller.text));

  void clear() => controller.clear();

  void updateValue({
    String? taskId,
    String? title,
    ChecklistStatus? status,
  }) =>
      state = state.copyWith(
        taskId: taskId ?? state.taskId,
        title: title ?? state.title,
        status: status ?? state.status,
      );
}
