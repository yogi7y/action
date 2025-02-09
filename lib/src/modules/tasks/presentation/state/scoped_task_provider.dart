import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';

/// Override when laying out task tile inside of list builder to optimize rebuilds.
final scopedTaskProvider = Provider<TaskEntity>(
  (ref) => throw UnimplementedError('Should be overridden with a task entity'),
);
