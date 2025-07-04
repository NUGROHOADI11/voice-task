import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_task/constants/core/assets/image_constant.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../landing/controllers/landing_controller.dart';
import '../../controllers/profile_controller.dart';

Widget buildHeader(BuildContext context) {
  final ProfileController controller = Get.put(ProfileController());

  return GestureDetector(
      onTap: () => _showProfileDialog(context, controller),
      child: Obx(
        () => Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: controller.profilePictureUrl.value.isNotEmpty
                  ? NetworkImage(controller.profilePictureUrl.value)
                  : const AssetImage(ImageConstant.person)
                      as ImageProvider<Object>,
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Text(
                  controller.currentUser.value?.username ?? 'User',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  controller.currentUser.value?.address ?? 'Address not set'.tr,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ));
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
              SizedBox(width: 40.w),
            ],
          ),
          Obx(() => Container(
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
                      CircleAvatar(
                        radius: 30.w,
                        backgroundImage:
                            controller.profilePictureUrl.value.isNotEmpty
                                ? NetworkImage(controller.profilePictureUrl.value)
                                : const AssetImage(ImageConstant.person)
                                    as ImageProvider<Object>,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  controller.currentUser.value?.username ??
                                      'User',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.edit, size: 20.w),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 16.w, color: Colors.grey),
                                SizedBox(width: 4.w),
                                Text(
                                  controller.currentUser.value?.address ??
                                      'Address not set'.tr,
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
