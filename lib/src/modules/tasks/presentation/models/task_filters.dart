import 'package:meta/meta.dart';

import '../../../filter/domain/entity/filter.dart';
import '../../../filter/domain/entity/variants/equals_filter.dart';
import '../../domain/entity/filters/task_filter_operations.dart';
import '../../domain/entity/task_status.dart';

@immutable
class OrganizedFilter extends EqualsFilter {
  const OrganizedFilter({
    super.key = InMemoryTaskFilterOperations.isOrganizedKey,
    this.isOrganized = true,
  }) : super(value: isOrganized);

  final bool isOrganized;

  @override
  String toString() => 'OrganizedFilter(isOrganized: $isOrganized)';

  @override
  bool operator ==(covariant Filter other) {
    if (identical(this, other)) return true;

    return other is OrganizedFilter && other.isOrganized == isOrganized;
  }

  @override
  int get hashCode => isOrganized.hashCode;
}

@immutable
class StatusFilter extends EqualsFilter {
  StatusFilter(
    this.status,
  ) : super(
          key: InMemoryTaskFilterOperations.statusKey,
          value: status.value,
        );

  final TaskStatus status;

  @override
  String toString() => 'StatusFilter(status: $status)';

  @override
  bool operator ==(covariant Filter other) {
    if (identical(this, other)) return true;

    return other is StatusFilter && other.status == status;
  }

  @override
  int get hashCode => status.hashCode;
}

@immutable
class ProjectFilter extends EqualsFilter {
  const ProjectFilter(
    this.projectId,
  ) : super(
          key: InMemoryTaskFilterOperations.projectIdKey,
          value: projectId,
        );

  final String projectId;

  @override
  String toString() => 'ProjectFilter(projectId: $projectId)';

  @override
  bool operator ==(covariant Filter other) {
    if (identical(this, other)) return true;

    return other is ProjectFilter && other.projectId == projectId;
  }

  @override
  int get hashCode => projectId.hashCode;
}
