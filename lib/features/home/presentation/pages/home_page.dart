import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:weekplanner_pro/features/planner/application/planner_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(plannerProvider);
    final today = DateTime.now();

    final todayTasks = tasks.where((task) {
      return task.date.year == today.year &&
          task.date.month == today.month &&
          task.date.day == today.day;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Hi, welcome!',
          style: TextStyle(color: Colors.greenAccent),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: todayTasks.isEmpty
            ? const Center(
                child: Text(
                  'No tasks for today 🎉',
                  style: TextStyle(color: Colors.greenAccent),
                ),
              )
            : ListView.builder(
                itemCount: todayTasks.length,
                itemBuilder: (_, index) {
                  final task = todayTasks[index];
                  return Card(
                    color: Colors.grey[900],
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                      subtitle: Text(
                        task.description ?? '',
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                      trailing: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => ref
                            .read(plannerProvider.notifier)
                            .toggleTaskCompletion(task.id),
                        checkColor: Colors.black,
                        activeColor: Colors.greenAccent,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
