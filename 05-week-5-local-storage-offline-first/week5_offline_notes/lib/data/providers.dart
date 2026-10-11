import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local/note.dart';
import 'prefs.dart';
import 'repositories/note_repository.dart';
import 'sync.dart';

final prefsRepositoryProvider = Provider<PrefsRepository>((ref) => PrefsRepository());
final noteRepositoryProvider = Provider<NoteRepository>((ref) => NoteRepository());

final darkModeProvider = AsyncNotifierProvider<DarkModeNotifier, bool>(DarkModeNotifier.new);

class DarkModeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = ref.watch(prefsRepositoryProvider);
    await prefs.markOpenedNow();
    return prefs.getDarkMode();
  }

  Future<void> toggle() async {
    final next = !(state.asData?.value ?? false);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(prefsRepositoryProvider).setDarkMode(next);
      return next;
    });
  }
}

final forceOfflineProvider = AsyncNotifierProvider<ForceOfflineNotifier, bool>(ForceOfflineNotifier.new);

class ForceOfflineNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(prefsRepositoryProvider).getForceOffline();

  Future<void> toggle() async {
    final next = !(state.asData?.value ?? false);
    state = await AsyncValue.guard(() async {
      await ref.read(prefsRepositoryProvider).setForceOffline(next);
      return next;
    });
  }
}

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(
  NotesNotifier.new,
  retry: (retryCount, error) => null,
);

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() => ref.watch(noteRepositoryProvider).fetchNotes();

  Future<void> add({required String title, required String body}) async {
    await ref.read(noteRepositoryProvider).addNote(title: title, body: body);
    ref.invalidateSelf();
  }

  Future<void> editNote({required int id, required String title, required String body}) async {
    await ref.read(noteRepositoryProvider).updateNote(id: id, title: title, body: body);
    ref.invalidateSelf();
  }

  Future<void> delete(int id) async {
    await ref.read(noteRepositoryProvider).deleteNote(id);
    ref.invalidateSelf();
  }

  Future<int> sync() async {
    final count = await syncNotes(
      ref.read(noteRepositoryProvider),
      forceOffline: ref.read(forceOfflineProvider).asData?.value ?? false,
    );
    ref.invalidateSelf();
    return count;
  }
}
