import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';

import '../../../utils/services/firestore_service.dart';
import '../../note/sub_features/add_note/models/note_model.dart';

class DetailNoteController extends GetxController {
  static DetailNoteController get to => Get.find();

  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final Rxn<Note> note = Rxn<Note>();
  final Rxn<int> selectedColor = Rxn<int>();

  final quillController = QuillController.basic();
  final FocusNode quillFocusNode = FocusNode();

  final isLoading = false.obs;
  final isQuillFocused = false.obs;
  final isToolbarExpanded = false.obs;

  late String noteId;
  DateTime date = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    noteId = Get.arguments['noteId'];
    fetchNoteDetails(noteId);

    quillFocusNode.addListener(() {
      isQuillFocused.value = quillFocusNode.hasFocus;
      if (!quillFocusNode.hasFocus) {
        isToolbarExpanded.value = false;
      }
    });
  }

  void toggleToolbarExpansion() {
    isToolbarExpanded.value = !isToolbarExpanded.value;
  }

  Future<void> fetchNoteDetails(String noteId) async {
    try {
      isLoading.value = true;
      final docSnapshot = await FirestoreService().getNoteDocument(noteId);
      if (docSnapshot.exists && docSnapshot.data() != null) {
        note.value = Note.fromMap(
            docSnapshot.data()! as Map<String, dynamic>, docSnapshot.id);

        titleController.text = note.value?.title ?? '';
        if (note.value?.content != null) {
          final contentDelta = Delta.fromJson(jsonDecode(note.value!.content));
          quillController.document = Document.fromDelta(contentDelta);
        }

        selectedColor.value = note.value?.colorValue;
        date = note.value?.updatedAt ?? note.value!.createdAt;
      } else {
        Get.snackbar("Error", "Note not found.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch note details: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNote() async {
    try {
      isLoading.value = true;
      final contentAsJson =
          jsonEncode(quillController.document.toDelta().toJson());

      final updateData = Note(
        title: titleController.text,
        content: contentAsJson,
        colorValue: selectedColor.value,
        isPin: note.value!.isPin,
        isHidden: note.value!.isHidden,
        updatedAt: DateTime.now(),
      );
      await FirestoreService().updateNote(noteId, updateData.toMap());

      Get.back();
      Get.snackbar("Success", "Note updated successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to update note: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNote() async {
    try {
      isLoading.value = true;
      await FirestoreService().deleteNote(noteId);
      Get.back();
      Get.snackbar("Success", "Note deleted successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete, ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    quillController.dispose();
    quillFocusNode.dispose();
    super.onClose();
  }
}
