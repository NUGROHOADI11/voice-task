
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import '../../configs/routes/route.dart';
import '../../constants/core/api/api_constant.dart';

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
  }

  Future<void> checkConnection() async {
    try {
      List<ConnectivityResult> connectivityResults =
          await Connectivity().checkConnectivity();
      bool hasInternet = connectivityResults
          .any((result) => result != ConnectivityResult.none);
      isConnected.value = hasInternet;
      // if (!hasInternet) {
      //   Get.offAllNamed(Routes.offlineRoute);
      // }
    } catch (e) {
      isConnected.value = false;
    }
  }
}
