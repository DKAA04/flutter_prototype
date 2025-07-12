import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:weekplanner_pro/features/planner/domain/entities/planner_task.dart';

final plannerTasksProvider =
    StateNotifierProvider<PlannerNotifier, List<PlannerTask>>((ref) {
      return PlannerNotifier();
    });

class PlannerNotifier extends StateNotifier<List<PlannerTask>> {
  static const String _boxName = 'planner_tasks';

  late Box<PlannerTask> _box;

  PlannerNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = Hive.box<PlannerTask>(_boxName);
    state = _box.values.toList();
  }

  Future<void> addTask(PlannerTask task) async {
    await _box.put(task.id, task);
    state = _box.values.toList();
  }

  Future<void> toggleCompletion(String taskId) async {
    final task = _box.get(taskId);
    if (task != null) {
      final updatedTask = PlannerTask(
        id: task.id,
        title: task.title,
        description: task.description,
        date: task.date,
        isCompleted: !task.isCompleted,
      );
      await _box.put(task.id, updatedTask);
      state = _box.values.toList();
    }
  }

  Future<void> removeTask(String taskId) async {
    await _box.delete(taskId);
    state = _box.values.toList();
  }
}
