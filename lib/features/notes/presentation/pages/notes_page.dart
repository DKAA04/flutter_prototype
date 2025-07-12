import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../notes/domain/entities/note.dart';
import '../../../notes/application/note_notifier.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(noteProvider);
    final controller = TextEditingController();

    final sortedNotes = [...notes]
      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

    final now = DateTime.now();

    final todayNotes = sortedNotes
        .where(
          (n) =>
              n.dateCreated.year == now.year &&
              n.dateCreated.month == now.month &&
              n.dateCreated.day == now.day,
        )
        .toList();

    final olderNotes = sortedNotes
        .where(
          (n) =>
              !(n.dateCreated.year == now.year &&
                  n.dateCreated.month == now.month &&
                  n.dateCreated.day == now.day),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: notes.isEmpty
          ? const Center(
              child: Text(
                'No notes yet.',
                style: TextStyle(color: Colors.greenAccent),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (todayNotes.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Today\'s Notes',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...todayNotes
                      .map((note) => _buildNoteCard(note, ref, context))
                      .toList(),
                ],
                if (olderNotes.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Older Notes',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...olderNotes
                      .map((note) => _buildNoteCard(note, ref, context))
                      .toList(),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          controller.clear();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                'New Note',
                style: TextStyle(color: Colors.greenAccent),
              ),
              content: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.greenAccent),
                decoration: const InputDecoration(
                  labelText: 'Note',
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
                    final note = Note(
                      id: const Uuid().v4(),
                      content: controller.text,
                      dateCreated: DateTime.now(),
                    );
                    ref.read(noteProvider.notifier).addNote(note);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildNoteCard(Note note, WidgetRef ref, BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(
          note.content,
          style: const TextStyle(color: Colors.greenAccent),
        ),
        subtitle: Text(
          _formatDate(note.dateCreated),
          style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            ref.read(noteProvider.notifier).deleteNote(note.id);
          },
        ),
        onTap: () {
          final controller = TextEditingController(text: note.content);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                'Edit Note',
                style: TextStyle(color: Colors.greenAccent),
              ),
              content: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.greenAccent),
                decoration: const InputDecoration(
                  labelText: 'Note',
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
                    final updatedNote = note.copyWith(
                      content: controller.text,
                      // ❌ Removed: dateCreated: DateTime.now()
                    );
                    ref.read(noteProvider.notifier).editNote(updatedNote);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
