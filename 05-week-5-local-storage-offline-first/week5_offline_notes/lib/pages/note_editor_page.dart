import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/note.dart';
import '../data/providers.dart';

class NoteEditorPage extends ConsumerStatefulWidget {
  const NoteEditorPage({this.note, super.key});

  final Note? note;

  @override
  ConsumerState<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends ConsumerState<NoteEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul wajib diisi.')));
      return;
    }
    final notifier = ref.read(notesProvider.notifier);
    if (widget.note == null) {
      await notifier.add(title: title, body: _bodyController.text.trim());
    } else {
      await notifier.editNote(id: widget.note!.id!, title: title, body: _bodyController.text.trim());
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Catatan Baru' : 'Edit Catatan'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save_outlined))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: _titleController, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Judul', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: _bodyController, minLines: 8, maxLines: 15, decoration: const InputDecoration(labelText: 'Isi catatan', alignLabelWithHint: true, border: OutlineInputBorder())),
          const SizedBox(height: 18),
          FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('Simpan offline')),
          const SizedBox(height: 8),
          const Text('Catatan disimpan lokal dan diberi tanda belum tersinkron.', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
