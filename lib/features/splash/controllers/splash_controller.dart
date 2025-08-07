import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:voice_task/configs/routes/route.dart';
import '../../../utils/services/hive_service.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();

  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final bool permissionGranted = await _handleLocationPermission();

    if (!permissionGranted) {
      log("Location permission not granted. App stopped at splash.");
      return;
    }

    log("Permission OK. Navigating...");
    final user = FirebaseAuth.instance.currentUser;
    Get.offAllNamed(user != null ? Routes.homeRoute : Routes.onBoardRoute);

    _fetchAndSaveLocation();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location Services Disabled",
          "Please enable location services (GPS) on your device.");
      return false;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied",
            "This app requires location permission to function.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.defaultDialog(
        title: "Location Permission Required",
        middleText:
            "You have permanently denied location permission. Please enable it manually in the app settings.",
        textConfirm: "Open Settings",
        onConfirm: () async {
          Get.back();
          await Geolocator.openAppSettings();
        },
        textCancel: "Cancel",
      );
      return false;
    }

    return true;
  }

  Future<void> _fetchAndSaveLocation() async {
  try {
    log("Trying to fetch location...");
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        timeLimit: const Duration(seconds: 15),
      ),
    );
    log("Location obtained: Lat: ${position.latitude}, Lon: ${position.longitude}");

    log("Performing reverse geocoding...");
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String city = place.locality ?? 'Unknown'; 
      String province = place.administrativeArea ?? 'Unknown'; 
      String country = place.country ?? 'Unknown';

      log("Address found: $city, $province, $country");

      await LocalStorageService.saveUserLocation(
        city: city,
        province: province,
        country: country,
      );
    } else {
      log("Failed to perform reverse geocoding, no address found.");
    }
  } catch (e) {
    log("Failed to fetch or process location: $e");
  }
}
}
