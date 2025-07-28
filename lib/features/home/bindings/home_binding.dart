import 'package:get/get.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../../note/controllers/note_controller.dart';
import '../../task/controllers/task_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => NoteController(), fenix: true);
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}
