import 'package:get/get.dart';

import '../controllers/hidden_controller.dart';

class HiddenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HiddenController());
  }
}
