import 'package:meta/meta.dart';

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
  bool operator ==(covariant OrganizedFilter other) {
    if (identical(this, other)) return true;

    return other.isOrganized == isOrganized;
  }

  @override
  int get hashCode => isOrganized.hashCode;
}

@immutable
class StatusFilter extends EqualsFilter {
  const StatusFilter(
    this.status,
  ) : super(
          key: InMemoryTaskFilterOperations.statusKey,
          value: status,
        );

  final TaskStatus status;

  @override
  String toString() => 'StatusFilter(status: $status)';

  @override
  bool operator ==(covariant StatusFilter other) {
    if (identical(this, other)) return true;

    return other.status == status;
  }

  @override
  int get hashCode => status.hashCode;
}
