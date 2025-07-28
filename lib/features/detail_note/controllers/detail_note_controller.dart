import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

import '../../note/repositories/note_repository.dart';
import '../../note/sub_features/add_note/models/note_model.dart';

class DetailNoteController extends GetxController {
  static DetailNoteController get to => Get.find();

  final titleController = TextEditingController();
  final noteRepo = NoteRepository();
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

      final localNote = noteRepo.getNoteById(noteId);
      if (localNote != null) {
        note.value = localNote;
      } else {
        Get.snackbar("Offline", "Note not found locally.",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      titleController.text = note.value?.title ?? '';
      if (note.value?.content != null) {
        final contentDelta = Delta.fromJson(jsonDecode(note.value!.content));
        quillController.document = Document.fromDelta(contentDelta);
      }

      selectedColor.value = note.value?.colorValue;
      date = note.value?.updatedAt ?? note.value!.createdAt;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch note: ${e.toString()}",
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

      final updatedNote = Note(
        id: noteId,
        title: titleController.text,
        content: contentAsJson,
        colorValue: selectedColor.value,
        isPin: note.value!.isPin,
        isHidden: note.value!.isHidden,
        createdAt: note.value!.createdAt,
        updatedAt: DateTime.now(),
      );

      await noteRepo.updateNote(noteId, updatedNote);

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

  void confirmDeleteNote() {
    Get.defaultDialog(
      title: "Confirm Deletion",
      middleText: "Are you sure you want to delete this note?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await deleteNote();
      },
    );
  }

  Future<void> deleteNote() async {
    try {
      isLoading.value = true;
      await noteRepo.deleteNote(noteId);

      Get.back();
      Get.snackbar("Success", "Note deleted successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
      log("Error deleting note: $e");
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
