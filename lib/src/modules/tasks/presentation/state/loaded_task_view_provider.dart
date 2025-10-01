import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_list_view_data.dart';

/// A list of in-memory loaded task views.
/// What this means is that these task views were accessed and loaded in-memory for this app session.
///
/// When a task is updated, it'll be run through all these views to see if it should be added/removed from the view.
final loadedTaskListViewDataProvider = StateProvider<Set<TaskListViewData>>((ref) => {});
