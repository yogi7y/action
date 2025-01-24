import '../../../../shared/checkbox/checkbox.dart';

enum ProjectStatus {
  notStarted('not_started', 'Not Started'),
  onHold('on_hold', 'On Hold'),
  doNext('do_next', 'Do Next'),
  inProgress('in_progress', 'In Progress'),
  done('done', 'Done'),
  archive('archive', 'Archive');

  const ProjectStatus(this.value, this.displayStatus);

  /// The string value used to represent this status in the database
  final String value;

  /// The human-readable display text for this status
  final String displayStatus;

  static ProjectStatus fromString(String status) {
    return ProjectStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => throw ArgumentError('Invalid project status: $status'),
    );
  }

  /// Convert the project status to an AppCheckboxState.
  AppCheckboxState toAppCheckboxState() => AppCheckboxState.fromProjectStatus(status: this);
}
