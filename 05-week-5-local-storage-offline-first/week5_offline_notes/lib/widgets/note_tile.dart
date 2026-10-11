import 'package:flutter/material.dart';

import '../data/local/note.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({required this.note, required this.onTap, required this.onDelete, super.key});

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(note.body.isEmpty ? 'Tidak ada isi catatan' : note.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        leading: Icon(note.dirty ? Icons.cloud_upload_outlined : Icons.check_circle_outline),
        trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
      ),
    );
  }
}
