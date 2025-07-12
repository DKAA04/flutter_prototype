import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../domain/entities/thought.dart';

final thoughtProvider = StateNotifierProvider<ThoughtNotifier, List<Thought>>((
  ref,
) {
  return ThoughtNotifier();
});

class ThoughtNotifier extends StateNotifier<List<Thought>> {
  ThoughtNotifier() : super([]) {
    _loadThoughts();
  }

  Future<void> _loadThoughts() async {
    final box = Hive.box<Thought>('thoughts');
    state = box.values.toList();
  }

  Future<void> addThought(Thought thought) async {
    final box = Hive.box<Thought>('thoughts');
    await box.put(thought.id, thought);
    state = [...state, thought];
  }

  Future<void> deleteThought(String id) async {
    final box = Hive.box<Thought>('thoughts');
    await box.delete(id);
    state = state.where((t) => t.id != id).toList();
  }
}
