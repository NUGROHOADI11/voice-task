import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_task/constants/core/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/landing_controller.dart';
import '../components/build_auth_form.dart';
import '../components/build_forgot.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});

  final controller = LandingController.to;
  final RxBool isLogin = true.obs;
  final RxBool isForgot = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      appBar: AppBar(
        backgroundColor: ColorStyle.white,
        title: Image.asset(
          ImageConstant.logoName,
          width: 130,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'VoiceTask',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Convert your voice into tasks instantly and efficiently — perfect for boosting your daily productivity.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 40.h),
              if (isForgot.value)
                buildForgotPasswordForm(context, isForgot)
              else
                buildAuthForm(context, isLogin, isForgot),
            ],
          );
        }),
      ),
    );
  }
}
