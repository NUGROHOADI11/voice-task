import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../../configs/routes/route.dart';
import '../../../../constants/core/assets/image_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../constants/on_board_assets_constant.dart';

class OnBoardScreen extends StatelessWidget {
  OnBoardScreen({super.key});

  final assetsConstant = OnBoardAssetsConstant();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset(
            ImageConstant.logoApk,
            width: 30,
          ),
          centerTitle: true,
        ),
        body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Welcome to VoiceTask".tr,
              body:
                  "Whether you’re on the go, in a meeting, or cooking dinner, VoiceTask helps you capture ideas, create tasks, and set reminders — all hands-free.".tr,
              image: buildImage(ImageConstant.onBoard1),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "Let Your Voice Do the Work".tr,
              body:
                  "Start your journey with VoiceTask today — and experience productivity that listens.".tr,
              image: buildImage(ImageConstant.onBoard1),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: "Ready When You Are".tr,
              body:
                  "VoiceTask is always listening — so you don’t miss a beat. Tap the mic, speak your mind, and let us handle the rest.".tr,
              image: buildImage(ImageConstant.onBoard1),
              // footer: ,
              decoration: getPageDecoration(),
            ),
          ],
          done: const Text("Mulai",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: ColorStyle.primary)),
          onDone: () => Get.offAllNamed(Routes.landingRoute),
          next: const Icon(Icons.arrow_forward),
          skip: const Icon(Icons.keyboard_double_arrow_right),
          showSkipButton: true,
          dotsDecorator: const DotsDecorator(
            size: Size(5, 5),
            activeSize: Size(8, 8),
            color: ColorStyle.grey,
            activeColor: ColorStyle.black,
            spacing: EdgeInsets.symmetric(horizontal: 5),
          ),
          globalBackgroundColor: Colors.white,
        ));
  }

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 300));

  PageDecoration getPageDecoration() => const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 16, color: Colors.black54),
        imagePadding: EdgeInsets.all(20),
        pageColor: Colors.white,
      );
}
