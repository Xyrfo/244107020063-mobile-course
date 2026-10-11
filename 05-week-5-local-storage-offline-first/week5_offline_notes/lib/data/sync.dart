import 'api_client.dart';
import 'local/note.dart';
import 'local/post.dart';
import 'repositories/note_repository.dart';

Future<int> syncNotes(NoteRepository repository, {bool forceOffline = false}) async {
  if (forceOffline) throw StateError('Mode offline aktif. Sinkronisasi ditunda.');
  final dirty = await repository.fetchDirty();
  if (dirty.isEmpty) return 0;

  // Simulasi upload berurutan. Pada aplikasi nyata, kirim setiap note ke API.
  await Future.delayed(const Duration(milliseconds: 700));
  await repository.markAllSynced();
  return dirty.length;
}

List<Note> sortNotesNewestFirst(Iterable<Note> notes) {
  return notes.toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
}

Future<List<CachedPost>> loadPostsCacheFirst({
  required NoteRepository repository,
  PostsRemoteSource? remote,
  bool forceOffline = false,
}) async {
  final cached = await repository.readCachedPosts();
  if (!forceOffline) {
    // Cache dikembalikan seketika; refresh network terjadi setelahnya.
    Future<void>(() async {
      try {
        final fresh = await (remote ?? PostsRemoteSource()).fetchPosts();
        await repository.saveCachedPosts(fresh);
      } catch (_) {
        // Cache tetap menjadi sumber data ketika refresh gagal.
      }
    });
  }
  return cached;
}
