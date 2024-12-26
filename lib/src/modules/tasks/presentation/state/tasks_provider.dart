import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import 'new_task_provider.dart';

final scopedTaskProvider = Provider<TaskEntity>(
    (ref) => throw UnimplementedError('Ensure to override scopedTaskProvider'));

final tasksProvider = AsyncNotifierProvider<TasksNotifier, Tasks>(TasksNotifier.new);

class TasksNotifier extends AsyncNotifier<Tasks> {
  late final TaskUseCase _useCase = ref.read(taskUseCaseProvider);

  late final animatedListKey = GlobalKey<SliverAnimatedListState>(debugLabel: 'Animated list key');

  @override
  Future<List<TaskEntity>> build() async {
    return _fetchTasks();
  }

  Future<Tasks> _fetchTasks() => _useCase.fetchTasks().then((result) {
        return result.fold(
          onSuccess: (tasks) => tasks,
          onFailure: (error) => throw error,
        );
      });

  Future<void> addTask() async {
    final _task = ref.read(newTaskProvider);

    final _previousState = state;

    const _id = '';
    final _createdAt = DateTime.now();
    final _updatedAt = _createdAt;
    final _tempTask = TaskEntity.fromTaskProperties(
      task: _task,
      createdAt: _createdAt,
      updatedAt: _updatedAt,
      id: _id,
    );

    state = AsyncData([_tempTask, ...state.valueOrNull ?? []]);
    animatedListKey.currentState?.insertItem(0);
    _clearInput();

    try {
      final result = await _useCase.createTask(_task);

      await result.fold(
        onSuccess: (task) async {
          final currentTasks = state.valueOrNull ?? [];

          final updatedTasks = currentTasks
              .map((taskItem) => taskItem.name == _tempTask.name ? task : taskItem)
              .toList();

          state = AsyncData(updatedTasks);
        },
        onFailure: (error) async {
          state = _previousState;
          throw error;
        },
      );
    } catch (e) {
      state = _previousState;
      rethrow;
    } finally {
      ref.invalidate(newTaskProvider);
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    final _previousState = state;

    state = AsyncData(
      state.valueOrNull?.map((taskItem) {
            return taskItem.id == task.id ? task : taskItem;
          }).toList() ??
          [],
    );

    try {
      final result = await _useCase.updateTask(task);

      await result.fold(
        onSuccess: (task) async {
          final currentTasks = state.valueOrNull ?? [];

          final updatedTasks =
              currentTasks.map((taskItem) => taskItem.id == task.id ? task : taskItem).toList();

          state = AsyncData(updatedTasks);
        },
        onFailure: (error) async {
          state = _previousState;
          throw error;
        },
      );
    } catch (e) {
      state = _previousState;
      rethrow;
    }
  }

  void _clearInput() => ref.read(newTaskProvider.notifier).clear();
}
