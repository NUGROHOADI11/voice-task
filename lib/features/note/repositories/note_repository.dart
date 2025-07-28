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

    for (var note in notes) {
      try {
        
        if (note.isDeleted) {
          if (note.id != null) {
            await FirestoreService().deleteNote(note.id!);  
          }
          await _noteBox.delete(note.id); 
          continue;
        }

        
        final noteMap = note.toMap();
        noteMap.remove('isSynced');
        noteMap.remove('isDeleted');

        await FirestoreService().addNote(noteMap, docId: note.id);

        
        final updatedNote = Note.fromUpdate(
          originalNote: note,
          updateData: {
            'updatedAt': DateTime.now(),
            'isSynced': true,
          },
        );
        await _noteBox.put(note.id, updatedNote);
      } catch (e) {
        log("Failed to sync note ${note.id}: $e");
      }
    }
  }
  
  Future<void> syncNotesFromFirebase() async {
    final snapshot = await FirestoreService().getDataNotes().first;
    for (var doc in snapshot.docs) {
      final note = Note.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      await addNote(note);
    }
  }

  Future<void> addNote(Note note) async {
    note.id ??= DateTime.now().millisecondsSinceEpoch.toString();
    note = Note.fromUpdate(
      originalNote: note,
      updateData: {
        'isSynced': false,
        'isDeleted': false,
      },
    );
    await _noteBox.put(note.id, note);
  }

  Future<void> updateNote(String id, Note updatedNote) async {
    if (_noteBox.containsKey(id)) {
      updatedNote = Note.fromUpdate(
        originalNote: updatedNote,
        updateData: {
          'updatedAt': DateTime.now(),
          'isSynced': false,
          'isDeleted': false,
        },
      );
      await _noteBox.put(id, updatedNote);
    } else {
      throw Exception('Note with id $id not found');
    }
  }

  Future<void> deleteNote(String id) async {
    if (_noteBox.containsKey(id)) {
      final note = _noteBox.get(id)!;
      final markedNote = Note.fromUpdate(originalNote: note, updateData: {
        'isDeleted': true,
        'isSynced': false,
        'updatedAt': DateTime.now(),
      });
      await _noteBox.put(id, markedNote);
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

  Stream<List<Note>> watchNotes() {
    return _noteBox.watch().map((event) {
      return _noteBox.values.toList();
    });
  }
}
