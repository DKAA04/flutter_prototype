import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime dateCreated;

  Note({required this.id, required this.content, required this.dateCreated});

  Note copyWith({String? id, String? content, DateTime? dateCreated}) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }
}
