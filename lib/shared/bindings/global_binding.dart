import 'package:get/get.dart';
import '../controllers/global_controller.dart';

class GlobalBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
  }
}
