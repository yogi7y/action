import '../../domain/entity/task_entity.dart';
import '../models/task_list_view_data.dart';

mixin InMemoryTaskOperations {
  void handleInMemoryTaskOperations(
    TaskEntity task,
    Set<TaskListViewData> loadedViews,
  ) {
    throw UnimplementedError();
  }
}
