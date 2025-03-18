import '../../../../shared/checkbox/checkbox.dart';

enum TaskStatus {
  todo('todo', 'To Do'),
  doNext('do_next', 'Do Next'),
  inProgress('in_progress', 'In Progress'),
  done('done', 'Done'),
  discard('discard', 'Discard');

  const TaskStatus(this.value, this.displayStatus);

  /// The string value used to represent this status in the database
  final String value;

  /// The human-readable display text for this status
  final String displayStatus;

  static TaskStatus fromString(String status) => TaskStatus.values.firstWhere(
        (e) => e.value == status,
        orElse: () => throw ArgumentError('Invalid task status: $status'),
      );

  /// Convert from AppCheckboxState to TaskStatus
  static TaskStatus fromAppCheckboxState(AppCheckboxState state) {
    return switch (state) {
      AppCheckboxState.checked => TaskStatus.done,
      AppCheckboxState.intermediate => TaskStatus.inProgress,
      AppCheckboxState.unchecked => TaskStatus.todo,
    };
  }

  /// Convert the task status to an AppCheckboxState
  AppCheckboxState toAppCheckboxState() => switch (this) {
        TaskStatus.todo || TaskStatus.doNext => AppCheckboxState.unchecked,
        TaskStatus.inProgress => AppCheckboxState.intermediate,
        TaskStatus.done || TaskStatus.discard => AppCheckboxState.checked,
      };
}
