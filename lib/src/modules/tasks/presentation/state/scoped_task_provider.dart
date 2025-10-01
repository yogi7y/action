import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task_entity.dart';
import '../models/task_list_view_data.dart';

typedef IndexedTask = ({
  /// Index of the task in the list.
  int index,

  /// Task entity.
  TaskEntity task,

  /// Task list view data. (Filters, etc.)
  TaskListViewData taskListViewData,
});

/// Override when laying out task tile inside of list builder to optimize rebuilds.
final scopedTaskProvider = Provider<IndexedTask>(
  (ref) => throw UnimplementedError('Should be overridden with a task entity'),
);
