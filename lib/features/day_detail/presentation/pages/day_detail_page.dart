import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../planner/application/planner_notifier.dart';
import '../../../planner/domain/entities/planner_task.dart';
import '../../../planner/presentation/widgets/edit_task_dialog.dart';

class DayDetailPage extends ConsumerWidget {
  final DateTime date;

  const DayDetailPage({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(plannerProvider);

    final dayTasks = tasks
        .where(
          (task) =>
              task.date.year == date.year &&
              task.date.month == date.month &&
              task.date.day == date.day,
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '${_getDayName(date)}\'s Tasks',
          style: const TextStyle(color: Colors.greenAccent),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: dayTasks.isEmpty
            ? const Center(
                child: Text(
                  'No tasks for this day.',
                  style: TextStyle(color: Colors.greenAccent),
                ),
              )
            : ListView.builder(
                itemCount: dayTasks.length,
                itemBuilder: (_, index) {
                  final task = dayTasks[index];
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
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) {
                          ref
                              .read(plannerProvider.notifier)
                              .toggleTaskCompletion(task.id);
                        },
                        checkColor: Colors.black,
                        activeColor: Colors.greenAccent,
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.greenAccent,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => EditTaskDialog(task: task),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: Colors.grey[900],
                                  title: const Text(
                                    'Delete Task?',
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                  content: const Text(
                                    'Are you sure you want to delete this task?',
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref
                                            .read(plannerProvider.notifier)
                                            .deleteTask(task.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _getDayName(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[date.weekday - 1];
  }
}
