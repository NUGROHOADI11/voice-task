import 'package:get/get.dart';
import 'package:voice_task/features/splash/controllers/splash_controller.dart';

import '../../landing/controllers/landing_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => LandingController(), fenix: true);
  }
}
