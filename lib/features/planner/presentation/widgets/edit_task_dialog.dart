import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekplanner_pro/features/planner/application/planner_notifier.dart';
import '../../domain/entities/planner_task.dart';

class EditTaskDialog extends ConsumerStatefulWidget {
  final PlannerTask task;

  const EditTaskDialog({super.key, required this.task});

  @override
  ConsumerState<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends ConsumerState<EditTaskDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Edit Task',
        style: TextStyle(color: Colors.greenAccent),
      ),
      content: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.greenAccent),
        decoration: const InputDecoration(
          labelText: 'Task',
          labelStyle: TextStyle(color: Colors.greenAccent),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTask = widget.task.copyWith(
              title: _controller.text,
              // ✅ PRESERVE original date
              date: widget.task.date,
            );
            ref.read(plannerProvider.notifier).editTask(updatedTask);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
          child: const Text('Save', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
