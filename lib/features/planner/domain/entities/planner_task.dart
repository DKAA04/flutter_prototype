import 'package:hive/hive.dart';

part 'planner_task.g.dart'; // Hive-generated adapter

@HiveType(typeId: 0)
class PlannerTask extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final bool isCompleted;

  PlannerTask({
    required this.id,
    required this.title,
    this.description,
    required DateTime date,
    this.isCompleted = false,
  }) : date = DateTime(
         date.year,
         date.month,
         date.day,
       ); // 🔒 Normalized to avoid time-based bugs

  /// Returns a copy of this task with optional field overrides
  PlannerTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
  }) {
    return PlannerTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date != null
          ? DateTime(date.year, date.month, date.day)
          : this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
