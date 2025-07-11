import 'dart:developer';

import 'package:hive_ce/hive.dart';
import '../../../utils/services/firestore_service.dart';
import '../constants/note_api_constant.dart';
import '../sub_features/add_note/models/note_model.dart';

class NoteRepository {
  NoteRepository._internal();
  static final NoteRepository _instance = NoteRepository._internal();
  factory NoteRepository() => _instance;

  final NoteApiConstant apiConstant = NoteApiConstant();
  final Box<Note> _noteBox = Hive.box<Note>('notes');

  Future<void> syncNotesToFirebase() async {
    final notes = _noteBox.values.toList();
    if (notes.isEmpty) return;

    for (var note in notes) {
      try {
        await FirestoreService().addNote(note.toMap());
        await _noteBox.clear();
      } catch (e) {
        log("Failed to sync note ${note.id}: $e");
      }
    }
  }

  Future<void> addNote(Note note) async {
    if (note.id == null || note.id!.isEmpty) {
      note.id = DateTime.now().millisecondsSinceEpoch.toString();
    }
    await _noteBox.put(note.id, note);
  }

  Future<void> updateNote(String id, Note updatedNote) async {
    if (_noteBox.containsKey(id)) {
      await _noteBox.put(id, updatedNote);
    } else {
      throw Exception('Note with id $id not found');
    }
  }

  Future<void> deleteNote(String id) async {
    if (_noteBox.containsKey(id)) {
      await _noteBox.delete(id);
    } else {
      throw Exception('Note with id $id not found');
    }
  }

  Future<void> deleteAllNotes() async {
    await _noteBox.clear();
  }

  List<Note> getAllNotes() {
    return _noteBox.values.toList();
  }

  Note? getNoteById(String id) {
    return _noteBox.get(id);
  }
}
