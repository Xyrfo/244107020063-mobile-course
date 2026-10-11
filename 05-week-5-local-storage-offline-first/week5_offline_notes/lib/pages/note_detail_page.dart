import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/note.dart';
import '../data/providers.dart';
import 'note_editor_page.dart';

class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider).asData?.value ?? const <Note>[];
    Note? note;
    for (final item in notes) {
      if (item.id == id) note = item;
    }
    if (note == null) {
      return Scaffold(appBar: AppBar(title: const Text('Detail Catatan')), body: const Center(child: Text('Catatan tidak ditemukan.')));
    }
    final selected = note;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteEditorPage(note: selected))), icon: const Icon(Icons.edit_outlined))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(selected.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Row(children: [Icon(selected.dirty ? Icons.cloud_upload_outlined : Icons.check_circle_outline, size: 18), const SizedBox(width: 6), Text(selected.dirty ? 'Belum tersinkron' : 'Tersinkron')]),
          const Divider(height: 32),
          Text(selected.body.isEmpty ? 'Tidak ada isi catatan.' : selected.body, style: Theme.of(context).textTheme.bodyLarge),
        ]),
      ),
    );
  }
}
