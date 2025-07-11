import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../configs/routes/route.dart';
import '../../../../constants/core/assets/image_constant.dart';
import '../../../../shared/controllers/global_controller.dart';
import '../../../landing/controllers/landing_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final authControl = Get.put(LandingController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (GlobalController.to.isConnected.value == false) {
        Get.offAllNamed(Routes.offlineRoute);
        return;
      } 
      Get.offAllNamed(user != null ? Routes.homeRoute : Routes.onBoardRoute);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageConstant.logoApk,
              width: 50.w,
              height: 50.h,
            ),
            const Text(
              'VoiceTask',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
