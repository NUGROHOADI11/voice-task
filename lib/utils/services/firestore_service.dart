import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Task
  Stream<QuerySnapshot> getDataTask() {
    return _db.collection('tasks').snapshots();
  }

  Future<DocumentSnapshot> getTaskDocument(String taskId) {
    return _db.collection('tasks').doc(taskId).get();
  }

  Future<String> addTask(Map<String, dynamic> task) async {
    final docRef =
        await FirebaseFirestore.instance.collection('tasks').add(task);
    return docRef.id;
  }

  Future<void> updateTask(String id, Map<String, dynamic> data) {
    return _db.collection('tasks').doc(id).update(data);
  }

  Future<void> deleteTask(String id) {
    return _db.collection('tasks').doc(id).delete();
  }

  // Note
  Stream<QuerySnapshot> getDataNotes() {
    return _db.collection('notes').snapshots();
  }

  Future<DocumentSnapshot> getNoteDocument(String taskId) {
    return _db.collection('notes').doc(taskId).get();
  }

  Future<void> addNote(Map<String, dynamic> note) {
    return _db.collection('notes').add(note);
  }

  Future<void> updateNote(String id, Map<String, dynamic> data) {
    return _db.collection('notes').doc(id).update(data);
  }

  Future<void> deleteNote(String id) {
    return _db.collection('notes').doc(id).delete();
  }

  // User
  Future<void> addUser(Map<String, dynamic> user) {
    return _db.collection('users').add(user);
  }

  Future<DocumentSnapshot<Object?>> getUserDetail(String id) {
    return _db.collection('users').doc(id).get();
  }

  Future<DocumentSnapshot?> getUserByEmail(String email) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first;
      } else {
        return null;
      }
    } catch (e) {
      log("Error fetching user by email: $e");
      return null;
    }
  }

  Stream<QuerySnapshot<Object?>> getUsers() {
    return _db.collection('users').snapshots();
  }

  Future<bool> isEmailExists(String email) async {
    final querySnapshot =
        await _db.collection('users').where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) {
    return _db.collection('users').doc(id).update(data);
  }
}
