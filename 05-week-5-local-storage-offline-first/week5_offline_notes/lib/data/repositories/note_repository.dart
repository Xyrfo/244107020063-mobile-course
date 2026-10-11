import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import '../local/db.dart';
import '../local/note.dart';
import '../local/post.dart';

class NoteRepository {
  NoteRepository({Future<Database> Function()? openDb})
      : _openDb = openDb ?? openNotesDb;

  final Future<Database> Function() _openDb;

  Future<List<Note>> fetchNotes() async {
    final db = await _openDb();
    final rows = await db.query('notes', orderBy: 'updated_at DESC');
    return rows.map((row) => Note.fromMap(row)).toList();
  }

  Future<Note?> fetchNote(int id) async {
    final db = await _openDb();
    final rows = await db.query('notes', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Note.fromMap(rows.first);
  }

  Future<Note> addNote({required String title, String body = ''}) async {
    final db = await _openDb();
    final note = Note(title: title, body: body, updatedAt: DateTime.now(), dirty: true);
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  Future<Note> updateNote({required int id, required String title, String body = ''}) async {
    final db = await _openDb();
    final note = Note(id: id, title: title, body: body, updatedAt: DateTime.now(), dirty: true);
    await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [id]);
    return note;
  }

  Future<void> deleteNote(int id) async {
    final db = await _openDb();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countDirty() async {
    final db = await _openDb();
    final rows = await db.rawQuery('SELECT COUNT(*) AS c FROM notes WHERE dirty = 1');
    return (rows.first['c'] as num?)?.toInt() ?? 0;
  }

  Future<List<Note>> fetchDirty() async {
    final db = await _openDb();
    final rows = await db.query('notes', where: 'dirty = 1', orderBy: 'updated_at ASC');
    return rows.map((row) => Note.fromMap(row)).toList();
  }

  Future<void> markAllSynced() async {
    final db = await _openDb();
    await db.update('notes', {'dirty': 0}, where: 'dirty = 1');
  }

  Future<List<CachedPost>> readCachedPosts() async {
    final db = await _openDb();
    final rows = await db.query('cached_posts', orderBy: 'cached_at DESC');
    return rows.map((row) {
      final payload = jsonDecode(row['payload'] as String) as Map<String, dynamic>;
      return CachedPost.fromJson(payload);
    }).toList();
  }

  Future<void> saveCachedPosts(List<CachedPost> posts) async {
    final db = await _openDb();
    final batch = db.batch();
    for (final post in posts) {
      batch.insert(
        'cached_posts',
        {
          'id': post.id,
          'payload': jsonEncode(post.toJson()),
          'cached_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
