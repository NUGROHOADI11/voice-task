import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/core/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../profile/controllers/profile_controller.dart';

Widget buildGreetingCard() {
  return Container(
    margin: EdgeInsets.fromLTRB(16.w, 30.w, 16.w, 12.h),
    padding: const EdgeInsets.all(20.0),
    height: 150,
    width: double.infinity,
    decoration: BoxDecoration(
      color: ColorStyle.primary,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        _buildGreetingText(),
        Positioned(
          top: -60.h,
          right: -40.w,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Image.asset(
              ImageConstant.homeDecoration,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    ),
  );
}

Widget _buildGreetingText() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('How was your day'.tr,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          )),
      Text(
          '${ProfileController.to.currentUser.value?.username ?? 'User'}?',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          )),
   
    ],
  );
}
