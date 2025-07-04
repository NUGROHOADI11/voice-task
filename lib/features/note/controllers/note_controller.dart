import 'package:get/get.dart';
import '../../../utils/services/firestore_service.dart';
import '../sub_features/add_note/models/note_model.dart';

class NoteController extends GetxController {
  static NoteController get to => Get.put(NoteController());

  final FirestoreService _firestoreService = FirestoreService();

  var notes = <Note>[].obs;

  var filteredNotes = <Note>[].obs;

  var isLoading = true.obs;

  var isSearching = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    notes.bindStream(_getNotesStream());

    ever(notes, (_) => _filterNotes());
    ever(searchQuery, (_) => _filterNotes());
  }

  Stream<List<Note>> _getNotesStream() {
    isLoading.value = true;
    return _firestoreService.getDataNotes().map((snapshot) {
      try {
        List<Note> notes = snapshot.docs.map((doc) {
          return Note.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        isLoading.value = false;
        return notes;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", "Failed to parse notes: ${e.toString()}",
            snackPosition: SnackPosition.BOTTOM);
        return <Note>[];
      }
    }).handleError((error) {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to fetch notes: ${error.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  void _filterNotes() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredNotes.assignAll(notes);
    } else {
      filteredNotes.assignAll(notes.where((note) {
        final titleMatch = note.title.toLowerCase().contains(query);
        final contentMatch = note.content.toLowerCase().contains(query);
        return titleMatch || contentMatch;
      }).toList());
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
    }
  }

  // TODO: onCLose
}
