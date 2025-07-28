import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../../../repositories/note_repository.dart';
import '../models/note_model.dart';

class NoteAddNoteController extends GetxController {
  final titleController = TextEditingController();
  final QuillController quillController = QuillController.basic();
  final FocusNode quillFocusNode = FocusNode();
  final characterCount = 0.obs;
  final isLoading = false.obs;
  final isQuillFocused = false.obs;
  final isToolbarExpanded = false.obs;

  StreamSubscription? _quillChangesSubscription;

  @override
  void onInit() {
    super.onInit();

    _quillChangesSubscription =
        quillController.document.changes.listen((_) => _updateCharCount());
    quillFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    isQuillFocused.value = quillFocusNode.hasFocus;

    if (!quillFocusNode.hasFocus) {
      isToolbarExpanded.value = false;
    }
  }

  void toggleToolbarExpansion() {
    isToolbarExpanded.value = !isToolbarExpanded.value;
  }

  void _updateCharCount() {
    final plainText = quillController.document.toPlainText().trim();
    characterCount.value = plainText.length;
  }

  Future<void> saveNote() async {
    if (titleController.text.isEmpty) {
      Get.snackbar("Error", "Title cannot be empty.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (quillController.document.isEmpty()) {
      Get.snackbar("Error", "Content cannot be empty.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final contentAsJson =
          jsonEncode(quillController.document.toDelta().toJson());

      final newNote = Note(
        title: titleController.text,
        content: contentAsJson,
        createdAt: DateTime.now(),
      );

      NoteRepository().addNote(newNote);
      Get.back();

      Get.snackbar("Success", "Note added successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to add note: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();

    _quillChangesSubscription?.cancel();
    quillController.dispose();

    quillFocusNode.removeListener(_onFocusChange);
    quillFocusNode.dispose();

    super.onClose();
  }
}
