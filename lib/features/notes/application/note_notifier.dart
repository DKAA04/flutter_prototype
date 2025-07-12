import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../domain/entities/note.dart';

final noteProvider = StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
  return NoteNotifier();
});

class NoteNotifier extends StateNotifier<List<Note>> {
  NoteNotifier() : super([]) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final box = Hive.box<Note>('notes');
    state = box.values.toList();
  }

  Future<void> addNote(Note note) async {
    final box = Hive.box<Note>('notes');
    await box.put(note.id, note);

    // Re-fetch entire list to avoid duplication or mismatch
    await _loadNotes();
  }

  Future<void> deleteNote(String id) async {
    final box = Hive.box<Note>('notes');
    await box.delete(id);
    await _loadNotes();
  }

  Future<void> editNote(Note updatedNote) async {
    final box = Hive.box<Note>('notes');
    await box.put(updatedNote.id, updatedNote);
    await _loadNotes();
  }

  // Optional helper for quick inline editing (if used later)
  Future<void> updateNoteContent(String id, String newContent) async {
    final box = Hive.box<Note>('notes');
    final note = box.get(id);
    if (note != null) {
      final updated = note.copyWith(
        content: newContent,
        dateCreated: DateTime.now(),
      );
      await box.put(id, updated);
      await _loadNotes();
    }
  }
}
