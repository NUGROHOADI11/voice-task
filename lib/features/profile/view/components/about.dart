import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';
import 'bottom_sheet.dart';

Widget buildAboutMe() {
  final ProfileController controller = ProfileController.to;

  return Obx(() {
    final bioText = controller.currentUser.value?.bio;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'About Me'.tr,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        (bioText != null && bioText.isNotEmpty)
            ? bioText
            : 'No bio available'.tr,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit_outlined, size: 20.w),
        onPressed: () {
          customBottomSheet(
            title: "Edit Bio",
            initialValue: controller.bio.text,
            hintText: "Tell something about yourself",
            maxLines: 3,
            onSave: (value) {
              controller.bio.text = value;
              controller.updateBio();
            },
          );
        },
      ),
    );
  });
}
