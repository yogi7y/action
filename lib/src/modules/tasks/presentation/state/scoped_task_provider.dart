import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../models/task_view.dart';

typedef IndexedTask = ({int index, TaskEntity task});

/// Override when laying out task tile inside of list builder to optimize rebuilds.
final scopedTaskProvider = Provider<IndexedTask>(
  (ref) => throw UnimplementedError('Should be overridden with a task entity'),
);

/// Scoped provider for the current task view.
final scopedTaskViewProvider =
    Provider<TaskView>((ref) => throw UnimplementedError('Should be overridden with a task view'));
