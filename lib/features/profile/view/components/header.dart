import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_task/constants/core/assets/image_constant.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_button.dart';

import '../../../../utils/services/hive_service.dart';
import '../../../landing/controllers/landing_controller.dart';
import '../../controllers/profile_controller.dart';

Widget buildHeader(BuildContext context) {
  final ProfileController controller = Get.put(ProfileController());

  final Map<String, String>? addressData =
      LocalStorageService.getUserLocation();
  String locationText;

  if (addressData != null) {
    final String city = addressData['city'] ?? '';
    final String province = addressData['province'] ?? '';

    if (city.isNotEmpty &&
        city != 'Unknown' &&
        province.isNotEmpty &&
        province != 'Unknown') {
      locationText = '$city, $province';
    } else if (city.isNotEmpty && city != 'Unknown') {
      locationText = city;
    } else {
      locationText = 'Location not available'.tr;
    }
  } else {
    locationText = 'Location not available'.tr;
  }

  return GestureDetector(
    onTap: () => _showProfileDialog(context, controller, locationText),
    child: Obx(
      () => Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: controller.imageFile.value != null
                ? FileImage(controller.imageFile.value!)
                : controller.profilePictureUrl.value.isNotEmpty
                    ? NetworkImage(controller.profilePictureUrl.value)
                    : const AssetImage(ImageConstant.person)
                        as ImageProvider<Object>,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Text(
                  controller.currentUser.value?.username ?? 'User',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  locationText,
                  style: TextStyle(color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void _showProfileDialog(
    BuildContext context, ProfileController controller, String locationText) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: ColorStyle.light,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.close, size: 24.w),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'VoiceTask',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 48.w),
            ],
          ),
          Obx(
            () => Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await controller.pickImage();
                          if (controller.imageFile.value != null) {
                            await controller.uploadImage();
                          }
                        },
                        child: CircleAvatar(
                          radius: 30.w,
                          backgroundImage: controller.imageFile.value != null
                              ? FileImage(controller.imageFile.value!)
                              : controller.profilePictureUrl.value.isNotEmpty
                                  ? NetworkImage(
                                      controller.profilePictureUrl.value)
                                  : const AssetImage(ImageConstant.person)
                                      as ImageProvider<Object>,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: controller.isEditingUsername.value
                                      ? TextField(
                                          controller: controller.username,
                                          focusNode:
                                              controller.usernameFocusNode,
                                          autofocus: false,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                        )
                                      : Text(
                                          controller.currentUser.value
                                                  ?.username ??
                                              'User',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                                SizedBox(width: 8.w),
                                InkWell(
                                  onTap: () {
                                    if (controller.isEditingUsername.value) {
                                      Get.defaultDialog(
                                        title: "Confirm",
                                        middleText:
                                            "Are you sure you want to change your username?",
                                        onConfirm: () async {
                                          await controller.updateUsername();
                                          controller.isEditingUsername.value = false;
                                          controller.usernameFocusNode.unfocus();
                                          Get.back();
                                        },
                                        onCancel: () {
                                          controller.username.text = controller
                                                  .currentUser
                                                  .value
                                                  ?.username ??
                                              '';
                                          controller.isEditingUsername.value = false;
                                          controller.usernameFocusNode.unfocus();
                                          Get.back();
                                        },
                                      );
                                    } else {
                                      controller.isEditingUsername.value = true;
                                      Future.delayed(
                                          Duration(milliseconds: 100), () {
                                        controller.usernameFocusNode
                                            .requestFocus();
                                      });
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                        controller.isEditingUsername.value
                                            ? Icons.check
                                            : Icons.edit,
                                        size: 20.w,
                                        color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 16.w, color: Colors.grey),
                                SizedBox(width: 4.w),
                                Text(
                                  locationText,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35.h),
                  buildCustomButton(
                    () => _showLogoutConfirmation(context),
                    "Log Out",
                    ColorStyle.primary,
                    ColorStyle.light,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Log Out".tr),
      content: Text("Are you sure you want to log out?".tr),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel".tr,
              style: const TextStyle(color: ColorStyle.black)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);

            Navigator.pop(context);
            LandingController.to.logout();
          },
          child: Text("Log Out".tr,
              style: const TextStyle(color: ColorStyle.danger)),
        ),
      ],
    ),
  );
}
