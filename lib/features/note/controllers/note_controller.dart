import 'dart:developer';
import 'dart:async';

import 'package:get/get.dart';
import '../repositories/note_repository.dart';
import '../sub_features/add_note/models/note_model.dart';

class NoteController extends GetxController {
  static NoteController get to => Get.find();
  final noteRepo = NoteRepository();

  var notes = <Note>[].obs;
  var isLoading = true.obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  late StreamSubscription _noteSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
    _noteSubscription = noteRepo.watchNotes().listen((event) {
      log("Notes updated: $event");
      fetchNotes();
    });
  }

  void fetchNotes() {
    try {
      isLoading.value = true;
      notes.value = noteRepo.getAllNotes();
    } catch (e) {
      log("Error fetching offline data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
    }
  }

  void togglePin(id, Note note) {
    try {
      noteRepo.updateNote(
          id,
          Note(
            id: id,
            title: note.title,
            content: note.content,
            isPin: !note.isPin,
            updatedAt: DateTime.now(),
          ));
      fetchNotes();
    } catch (e) {
      log("Error toggling pin: $e");
      Get.snackbar("Error", "Failed to toggle pin: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    _noteSubscription.cancel();
    super.onClose();
  }
}
