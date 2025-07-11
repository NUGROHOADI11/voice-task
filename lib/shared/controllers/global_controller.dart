import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../configs/routes/route.dart';
import '../../constants/core/api/api_constant.dart';
import '../../features/landing/repositories/landing_repository.dart';
import '../../features/note/repositories/note_repository.dart';
import '../../features/task/repositories/task_repository.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.find();
  var isConnected = false.obs;
  var baseUrl = ApiConstant.production;
  var isStaging = false.obs;
  RxString statusLocation = RxString('loading');
  RxString messageLocation = RxString('');
  Rxn<Position> position = Rxn<Position>();
  RxnString address = RxnString();

  var locationPermissionGranted = false.obs;

  var lastReadAt = "".obs;

  void checkLocationPermission() async {
    var granted = await Permission.locationWhenInUse.status;

    locationPermissionGranted.value = granted == PermissionStatus.granted;
  }

  void requestLocationPermission() async {
    Permission.locationWhenInUse.request().then((value) {
      checkLocationPermission();
    });
  }

  @override
  void onInit() {
    super.onInit();
    checkConnection();

    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      bool hasInternet =
          results.any((result) => result != ConnectivityResult.none);
      isConnected.value = hasInternet;

      if (hasInternet) {
        final user = LandingRepository().getUserProfile();

        if (user != null) {
          try {
            await NoteRepository().syncNotesToFirebase();
            await TaskRepository().syncTasksToFirebase();
            log("Notes synced successfully");
          } catch (e) {
            log("Error syncing notes: $e");
          }

          if (Get.currentRoute == Routes.offlineRoute) {
            Get.offAllNamed(Routes.homeRoute);
          }
        } else {
          log("User not logged in, skipping sync.");
        }
      } else {
        Get.offAllNamed(Routes.offlineRoute);
      }
    });
  }

  Future<void> checkConnection() async {
    try {
      List<ConnectivityResult> connectivityResults =
          await Connectivity().checkConnectivity();
      bool hasInternet = connectivityResults
          .any((result) => result != ConnectivityResult.none);
      isConnected.value = hasInternet;
      if (!hasInternet) {
        Get.offAllNamed(Routes.offlineRoute);
      }
    } catch (e) {
      isConnected.value = false;
    }
  }
}
