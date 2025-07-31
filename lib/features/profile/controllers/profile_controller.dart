import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/styles/color_style.dart';
import '../../../utils/services/firestore_service.dart';
import '../../../utils/services/hive_service.dart';
import '../../landing/models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final String? language = LocalStorageService.getLanguagePreference();
  final RxString selectedLanguage = RxString('');

  final FirestoreService _firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  var username = TextEditingController();
  var email = TextEditingController();
  var bio = TextEditingController();
  var phone = TextEditingController();
  var address = TextEditingController();
  var pin = ''.obs;
  var isPinVisible = false.obs;
  var profilePictureUrl = ''.obs;
  var birthDate = ''.obs;
  var userId = ''.obs;

  var isLoading = false.obs;

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    final locale = languageCode == 'id'
        ? const Locale('id', 'ID')
        : const Locale('en', 'US');
    Get.updateLocale(locale);
    LocalStorageService.saveLanguagePreference(languageCode);
  }

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = language ?? '';
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user == null) {
      log("User not logged in.");
      Get.snackbar(
        "Error",
        "User not logged in.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorStyle.warning,
        colorText: ColorStyle.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final DocumentSnapshot<Object?>? data =
          await _firestoreService.getUserByEmail(user?.email ?? '');

      if (data != null && data.exists) {
        currentUser.value =
            UserModel.fromMap(data.data() as Map<String, dynamic>, data.id);
        userId.value = data.id;
        log("User ID: ${userId.value}");
        username.text = currentUser.value?.username ?? '';
        email.text = currentUser.value?.email ?? '';
        pin.value = currentUser.value?.pin ?? '';
        bio.text = currentUser.value?.bio ?? '';
        profilePictureUrl.value = currentUser.value?.photoUrl ?? '';
        birthDate.value = currentUser.value?.birthDate ?? '';
        phone.text = currentUser.value?.phoneNumber ?? '';
        address.text = currentUser.value?.address ?? '';
        log("User data fetched successfully: ${currentUser.value}");
      } else {
        log("User data not found.");
        Get.snackbar(
          "Error",
          "User data not found.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorStyle.warning,
          colorText: ColorStyle.white,
        );
      }
    } catch (e) {
      log("Error fetching user data: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch user data: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorStyle.danger,
        colorText: ColorStyle.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBio() async {
    if (currentUser.value == null) {
      log("No user data available to update.");
      Get.snackbar(
        "Error",
        "No user data available to update.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorStyle.warning,
        colorText: ColorStyle.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _firestoreService.updateUser(
        userId.value,
        {'bio': bio.text},
      );
      currentUser.value = UserModel.fromUpdate(
        currentUser.value!,
        {'bio': bio.text},
      );
      log("Bio updated successfully.");
    } catch (e) {
      log("Error updating bio: $e");
      Get.snackbar(
        "Error",
        "Failed to update bio: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorStyle.danger,
        colorText: ColorStyle.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEmail() async {
    if (user == null) {
      log("User not logged in.");
      Get.snackbar(
        "Error",
        "User not logged in.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorStyle.warning,
        colorText: ColorStyle.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await user!.verifyBeforeUpdateEmail(email.text);
      await _firestoreService.updateUser(
        userId.value,
        {'email': email.text},
      );
      log("Email updated successfully.");
    } catch (e) {
      log("Error updating email: $e");
      Get.snackbar(
        "Error",
        "Failed to update email: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorStyle.danger,
        colorText: ColorStyle.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyOldPin(String oldPin) async {
    return pin.value == oldPin;
  }

  Future<void> updatePin(String oldPin, String newPin) async {
    if (pin.value.isNotEmpty) {
      final isOldPinValid = await verifyOldPin(oldPin);
      if (!isOldPinValid) {
        Get.snackbar('Error', 'Old PIN is incorrect'.tr);
        return;
      }
    }

    try {
      isLoading.value = true;

      await _firestoreService.updateUser(
        userId.value,
        {'pin': newPin},
      );
      pin.value = newPin;
      Get.snackbar(
        'Success',
        'PIN updated successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log("Error updating PIN: $e");
      Get.snackbar(
        'Error',
        'Failed to update PIN: $e'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePhone() async {
    if (currentUser.value == null) {
      log("No user data available to update.");
      Get.snackbar(
        "Error",
        "No user data available to update.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorStyle.warning,
        colorText: ColorStyle.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _firestoreService.updateUser(
        userId.value,
        {'phoneNumber': phone.text},
      );
      currentUser.value = UserModel.fromUpdate(
        currentUser.value!,
        {'phoneNumber': phone.text},
      );
      log("Phone number updated successfully.");
    } catch (e) {
      log("Error updating phone number: $e");
      Get.snackbar(
        "Error",
        "Failed to update phone number: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorStyle.danger,
        colorText: ColorStyle.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
