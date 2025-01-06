import 'package:flutter/material.dart';

import 'task.dart';

@immutable
abstract class TaskQuerySpecification {
  const TaskQuerySpecification();

  TaskQuerySpecification and(TaskQuerySpecification other) => CompositeSpecification([this, other]);
}

// Composite specification to combine multiple specs
class CompositeSpecification extends TaskQuerySpecification {
  const CompositeSpecification(this.specifications);
  final List<TaskQuerySpecification> specifications;
}

@immutable
class AllTasksSpecification extends TaskQuerySpecification {
  const AllTasksSpecification();
}

@immutable
class StatusTaskSpecification extends TaskQuerySpecification {
  const StatusTaskSpecification(this.status);

  final TaskStatus status;
}

@immutable
class OrganizedStatusSpecification extends TaskQuerySpecification {
  const OrganizedStatusSpecification({
    this.isOrganized = true,
  });

  final bool isOrganized;
}
