import 'package:get/get.dart';

import '../controllers/note_controller.dart';
import '../sub_features/add_note/controllers/note_add_note_controller.dart';

class NoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NoteController(), fenix: true);
    Get.lazyPut(() => NoteAddNoteController(), fenix: true);
  }
}
