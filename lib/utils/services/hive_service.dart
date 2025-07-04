import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  static Future<void> clearBox() async {
    box.clear();
  }
}
