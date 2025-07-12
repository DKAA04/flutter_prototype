import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weekplanner_pro/features/planner/domain/entities/planner_task.dart';
import 'package:weekplanner_pro/features/thoughts/domain/entities/thought.dart';
import 'package:weekplanner_pro/features/notes/domain/entities/note.dart';
import 'package:weekplanner_pro/features/shared/presentation/widgets/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PlannerTaskAdapter());
  Hive.registerAdapter(ThoughtAdapter());
  Hive.registerAdapter(NoteAdapter());

  await Hive.openBox<PlannerTask>('planner_tasks');
  await Hive.openBox<Thought>('thoughts');
  await Hive.openBox<Note>('notes');

  runApp(const ProviderScope(child: WeekPlannerApp()));
}

class WeekPlannerApp extends StatelessWidget {
  const WeekPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week Planner Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.greenAccent),
        ),
      ),
      home: const MainScaffold(),
    );
  }
}
