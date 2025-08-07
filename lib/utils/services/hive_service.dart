import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class LocalStorageService extends GetxService {
  static late Box box;

  Future<LocalStorageService> init() async {
    box = await Hive.openBox("voice_task");
    return this;
  }

  static Future<void> saveLanguagePreference(String languageCode) async {
    await box.put("language_code", languageCode);
  }

  static String getLanguagePreference() {
    return box.get("language_code", defaultValue: 'en');
  }

  static Future<void> saveLocationPermission(bool isGranted) async {
    await box.put("location_permission", isGranted);
  }

  static bool getLocationPermission() {
    return box.get("location_permission", defaultValue: false);
  }

  static Future<void> saveUserLocation({
    required String city,
    required String province,
    required String country,
  }) async {
    final Map<String, String> addressData = {
      'city': city,
      'province': province,
      'country': country,
    };
    await box.put("user_address", addressData);
    log("Address data saved: $addressData");
  }

  static Map<String, String>? getUserLocation() {
    final dynamic addressData = box.get("user_address");
    if (addressData is Map) {
      return Map<String, String>.from(addressData);
    }
    return null;
  }

  static Future<void> clearBox() async {
    box.clear();
  }
}
