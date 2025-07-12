import 'package:hive/hive.dart';

part 'thought.g.dart';

@HiveType(typeId: 1)
class Thought extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime dateCreated;

  Thought({required this.id, required this.content, required this.dateCreated});
}
