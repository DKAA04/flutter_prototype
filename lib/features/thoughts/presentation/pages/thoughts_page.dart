import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../application/thought_notifier.dart';
import '../../domain/entities/thought.dart';

class ThoughtsPage extends ConsumerWidget {
  const ThoughtsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thoughts = ref.watch(thoughtProvider);
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Thoughts')),
      body: ListView.builder(
        itemCount: thoughts.length,
        itemBuilder: (_, index) {
          final thought = thoughts[index];
          return ListTile(
            title: Text(thought.content),
            subtitle: Text(thought.dateCreated.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(thoughtProvider.notifier).deleteThought(thought.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('New Thought'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'What’s on your mind?',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newThought = Thought(
                      id: const Uuid().v4(),
                      content: controller.text,
                      dateCreated: DateTime.now(),
                    );
                    ref.read(thoughtProvider.notifier).addThought(newThought);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
