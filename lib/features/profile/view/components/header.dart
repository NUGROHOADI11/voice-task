import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_task/constants/core/assets/image_constant.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_button.dart';

import '../../../../utils/services/hive_service.dart';
import '../../../landing/controllers/landing_controller.dart';
import '../../controllers/profile_controller.dart';
import 'bottom_sheet.dart';

Widget buildHeader(BuildContext context) {
  final ProfileController controller = Get.put(ProfileController());

  return GestureDetector(
    onTap: () => _showProfileDialog(context, controller),
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
                Obx(() => Text(
                      controller.locationText.value,
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void _showProfileDialog(BuildContext context, ProfileController controller) {
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
            children: [
              IconButton(
                icon: Icon(Icons.close, size: 24.w),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'Profile'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 30.w,
                              backgroundImage: controller.imageFile.value !=
                                      null
                                  ? FileImage(controller.imageFile.value!)
                                  : controller
                                          .profilePictureUrl.value.isNotEmpty
                                      ? NetworkImage(
                                          controller.profilePictureUrl.value)
                                      : const AssetImage(ImageConstant.person)
                                          as ImageProvider<Object>,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: ColorStyle.light,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  controller.isEditingUsername.value
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
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 16.w, color: Colors.grey),
                                      SizedBox(width: 4.w),
                                      Obx(() => Text(
                                            controller.locationText.value,
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                            overflow: TextOverflow.ellipsis,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _showEditOptionBottomSheet(controller);
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(Icons.edit,
                                    size: 16.w, color: Colors.grey[700]),
                              ),
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

void _showEditOptionBottomSheet(ProfileController controller) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Edit Name'.tr),
            onTap: () {
              Navigator.pop(Get.context!);
              _showEditNameBottomSheet(controller);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text('Edit Address'.tr),
            onTap: () {
              Navigator.pop(Get.context!);
              _showChangeLocationBottomSheet(controller);
            },
          ),
        ],
      ),
    ),
  );
}

void _showEditNameBottomSheet(ProfileController controller) {
  customBottomSheet(
    title: 'Change Username'.tr,
    initialValue: controller.currentUser.value?.username ?? '',
    hintText: 'Enter your new username'.tr,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Username cannot be empty'.tr;
      }
      if (value.length < 3) {
        return 'Username must be at least 3 characters'.tr;
      }
      return null;
    },
    onSave: (newName) async {
      controller.username.text = newName;
      await controller.updateUsername();
    },
  );
}

void _showChangeLocationBottomSheet(ProfileController controller) {
  customBottomSheet(
    title: 'Change Location'.tr,
    initialValue: '',
    hintText: 'Enter your city, province'.tr,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Location cannot be empty'.tr;
      }
      return null;
    },
    onSave: (newLocation) async {
      final parts = newLocation.split(',');
      final city = parts.isNotEmpty ? parts[0].trim() : 'Unknown';
      final province = parts.length > 1 ? parts[1].trim() : 'Unknown';

      await LocalStorageService.saveUserLocation(
        city: city,
        province: province,
        country: '',
      );

      controller.loadLocation();
      Get.snackbar("Success", "Location updated successfully");
    },
  );
}
