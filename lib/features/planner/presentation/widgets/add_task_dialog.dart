import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../application/planner_notifier.dart';
import '../../domain/entities/planner_task.dart';

class AddTaskDialog extends ConsumerWidget {
  final String day;
  const AddTaskDialog({super.key, required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    return AlertDialog(
      title: Text('Add Task for $day'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final task = PlannerTask(
              id: const Uuid().v4(),
              title: titleController.text.trim(),
              description: descController.text.trim(),
              date: _getDateFromDay(day),
            );

            ref.read(plannerProvider.notifier).addTask(task);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  DateTime _getDateFromDay(String day) {
    final now = DateTime.now();
    const dayMap = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    final targetWeekday = dayMap[day]!;
    final currentWeekday = now.weekday;

    int delta = targetWeekday - currentWeekday;
    if (delta < 0) delta += 7; // Go to next week if day already passed

    return DateTime(now.year, now.month, now.day).add(Duration(days: delta));
  }
}
