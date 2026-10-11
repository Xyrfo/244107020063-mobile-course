import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../widgets/note_tile.dart';
import 'note_editor_page.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  Future<void> _add(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NoteEditorPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final dirty = notesAsync.asData?.value.where((note) => note.dirty).length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes'),
        actions: [
          if (dirty > 0) Padding(padding: const EdgeInsets.only(right: 4), child: Center(child: Chip(label: Text('$dirty belum sync')))),
          IconButton(tooltip: 'Sinkronkan', onPressed: dirty == 0 ? null : () => _sync(context, ref), icon: const Icon(Icons.sync)),
          IconButton(tooltip: 'Pengaturan', onPressed: () => context.push('/settings'), icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _add(context), icon: const Icon(Icons.add), label: const Text('Catatan')),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.error_outline, size: 48), const SizedBox(height: 12), Text('Database lokal tidak dapat dibuka.'), Text('$error', textAlign: TextAlign.center), const SizedBox(height: 12), FilledButton(onPressed: () => ref.invalidate(notesProvider), child: const Text('Coba lagi'))]))),
        data: (notes) => notes.isEmpty ? const Center(child: Text('Belum ada catatan. Tambahkan catatan pertama.')) : ListView.builder(padding: const EdgeInsets.symmetric(vertical: 10), itemCount: notes.length, itemBuilder: (context, index) { final note = notes[index]; return NoteTile(note: note, onTap: () => context.push('/note/${note.id}'), onDelete: () => _delete(context, ref, note.id!)); }),
      ),
    );
  }

  Future<void> _sync(BuildContext context, WidgetRef ref) async {
    try {
      final count = await ref.read(notesProvider.notifier).sync();
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$count catatan berhasil disinkronkan.')));
    } catch (error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sync ditunda: $error')));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, int id) async {
    await ref.read(notesProvider.notifier).delete(id);
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Catatan dihapus.')));
  }
}
