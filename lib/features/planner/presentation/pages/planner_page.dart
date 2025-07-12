import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/planner_notifier.dart';
import '../widgets/add_task_dialog.dart';

class PlannerPage extends ConsumerStatefulWidget {
  const PlannerPage({super.key});

  @override
  ConsumerState<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends ConsumerState<PlannerPage> {
  final Map<String, bool> _expanded = {};

  @override
  void initState() {
    super.initState();
    for (var day in _days) {
      _expanded[day] = false;
    }
  }

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(plannerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Weekly Planner'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.greenAccent,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _days.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final day = _days[index];
          final dayTasks = tasks.where((t) => _getDay(t.date) == day).toList();
          final isExpanded = _expanded[day] ?? false;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _expanded[day] = !isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Card(
                color: Colors.grey[900],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            day,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.greenAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (isExpanded)
                        Expanded(
                          child: ListView(
                            children: dayTasks
                                .map(
                                  (task) => CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: task.isCompleted,
                                    title: Text(
                                      task.title,
                                      style: const TextStyle(
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                    onChanged: (_) => ref
                                        .read(plannerProvider.notifier)
                                        .toggleTaskCompletion(task.id),
                                    checkColor: Colors.black,
                                    activeColor: Colors.greenAccent,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.greenAccent,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AddTaskDialog(day: day),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDay(DateTime date) {
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
