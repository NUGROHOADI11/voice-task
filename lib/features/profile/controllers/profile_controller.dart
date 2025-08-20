import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/styles/color_style.dart';
import '../../../shared/widgets/image_picker_dialog.dart';
import '../../../utils/services/firestore_service.dart';
import '../../../utils/services/hive_service.dart';
import '../../landing/models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final supabase = Supabase.instance.client;

  final String? language = LocalStorageService.getLanguagePreference();
  final RxString selectedLanguage = RxString('');
  final RxString profileImageUrl = ''.obs;
  final Rx<File?> imageFile = Rx<File?>(null);
  final RxString imageUrl = RxString('');

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
  var isEditingUsername = false.obs;
  late FocusNode usernameFocusNode;
  var locationText = 'Location not set'.obs;

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
    usernameFocusNode = FocusNode();
    loadLocation();
    fetchUserData();
  }

  @override
  void onClose() {
    username.dispose();
    email.dispose();
    bio.dispose();
    phone.dispose();
    address.dispose();
    usernameFocusNode.dispose();
    super.onClose();
  }

  void loadLocation() {
    final data = LocalStorageService.getUserLocation();
    if (data != null) {
      final city = data['city'] ?? '';
      final province = data['province'] ?? '';

      if (city.isNotEmpty &&
          city != 'Unknown' &&
          province.isNotEmpty &&
          province != 'Unknown') {
        locationText.value = '$city, $province';
      } else if (city.isNotEmpty && city != 'Unknown') {
        locationText.value = city;
      } else {
        locationText.value = 'Location not available'.tr;
      }
    } else {
      locationText.value = 'Location not available'.tr;
    }
  }

  void toggleEditingUsername() {
    isEditingUsername.value = !isEditingUsername.value;
    if (isEditingUsername.value) {
      usernameFocusNode.requestFocus();
    } else {
      usernameFocusNode.unfocus();
      updateUsername();
    }
  }

  Future<void> fetchUserData() async {
    if (user == null) {
      log("User not logged in.");
      Get.snackbar(
        "Error",
        "User not logged in.",
        snackPosition: SnackPosition.TOP,
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
          snackPosition: SnackPosition.TOP,
          backgroundColor: ColorStyle.warning,
          colorText: ColorStyle.white,
        );
      }
    } catch (e) {
      log("Error fetching user data: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch user data: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: ColorStyle.danger,
        colorText: ColorStyle.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      ImageSource? imageSource = await Get.defaultDialog(
        title: '',
        titleStyle: const TextStyle(fontSize: 0),
        content: const ImagePickerDialog(),
      );

      if (imageSource == null) return;

      final pickedFile = await ImagePicker().pickImage(
        source: imageSource,
        maxWidth: 1400,
        maxHeight: 1400,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        await _cropImage(File(pickedFile.path));
      }
    } catch (e) {
      log("Error picking image: $e");
      Get.snackbar(
        'error'.tr,
        'failed_to_pick_image'.tr,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'cropper'.tr,
            toolbarColor: ColorStyle.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'cropper'.tr,
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        this.imageFile.value = File(croppedFile.path);
      }
    } catch (e) {
      log("Error cropping image: $e");
      throw Exception('failed_to_crop_image'.tr);
    }
  }

  Future<void> uploadImage() async {
    if (imageFile.value == null) {
      log("No image file selected.");
      Get.snackbar(
        'error'.tr,
        'no_image_selected'.tr,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final response = await supabase.storage
          .from(dotenv.env['SUPABASE_BUCKET_NAME']!)
          .uploadBinary(
            'image_url/$fileName',
            await imageFile.value!.readAsBytes(),
            fileOptions: FileOptions(contentType: 'image/jpeg'),
          );
      log("Image upload response: $response");

      currentUser.value = UserModel.fromUpdate(
        currentUser.value!,
        {'photoUrl': imageUrl.value},
      );

      imageUrl.value = supabase.storage
          .from(dotenv.env['SUPABASE_BUCKET_NAME']!)
          .getPublicUrl('image_url/$fileName');
      profileImageUrl.value = imageUrl.value;

      if (currentUser.value != null) {
        await _firestoreService.updateUser(
          userId.value,
          {'photoUrl': profileImageUrl.value},
        );
        currentUser.value = UserModel.fromUpdate(
          currentUser.value!,
          {'photoUrl': profileImageUrl.value},
        );
      }

      log("Image uploaded successfully: ${imageUrl.value}");
    } catch (e) {
      log("Error uploading image: $e");
      Get.snackbar(
        'error'.tr,
        'failed_to_upload_image'.tr,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUsername() async {
    isEditingUsername.value = false;

    if (currentUser.value == null) {
      log("No user data available to update.");
      Get.snackbar(
        "Error",
        "No user data available to update.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: ColorStyle.warning,
        colorText: ColorStyle.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _firestoreService.updateUser(
        userId.value,
        {'username': username.text},
      );
      currentUser.value = UserModel.fromUpdate(
        currentUser.value!,
        {'username': username.text},
      );
      log("Username updated successfully.");
    } catch (e) {
      log("Error updating username: $e");
      Get.snackbar(
        "Error",
        "Failed to update username: $e",
        snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      log("Error updating PIN: $e");
      Get.snackbar(
        'Error',
        'Failed to update PIN: $e'.tr,
        snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
        backgroundColor: ColorStyle.danger,
        colorText: ColorStyle.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
