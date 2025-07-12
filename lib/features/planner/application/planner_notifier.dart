import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:weekplanner_pro/features/planner/domain/entities/planner_task.dart';

final plannerProvider =
    StateNotifierProvider<PlannerNotifier, List<PlannerTask>>(
      (ref) => PlannerNotifier(),
    );

class PlannerNotifier extends StateNotifier<List<PlannerTask>> {
  PlannerNotifier() : super([]) {
    _loadTasks();
  }

  final _box = Hive.box<PlannerTask>('planner_tasks');

  /// Loads all tasks from Hive into memory
  void _loadTasks() {
    state = _box.values.toList();
  }

  /// Adds a new task
  Future<void> addTask(PlannerTask task) async {
    await _box.put(task.id, task);
    state = [...state, task];
  }

  /// Toggles a task's completion status
  Future<void> toggleTaskCompletion(String id) async {
    final task = _box.get(id);
    if (task == null) return;

    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await _box.put(id, updated);

    // Optimistic local update
    state = [
      for (final t in state)
        if (t.id == id) updated else t,
    ];
  }

  /// Deletes a task by ID
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
    state = state.where((t) => t.id != id).toList();
  }

  /// Edits an entire task
  Future<void> editTask(PlannerTask updatedTask) async {
    await _box.put(updatedTask.id, updatedTask);

    state = [
      for (final t in state)
        if (t.id == updatedTask.id) updatedTask else t,
    ];
  }
}
