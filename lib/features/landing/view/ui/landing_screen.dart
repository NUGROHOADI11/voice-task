import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_task/constants/core/assets/image_constant.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../constants/landing_assets_constant.dart';
import '../components/auth_bottom_sheet.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});

  final assetsConstant = LandingAssetsConstant();

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('VoiceTask',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w800,
                  )),
              const Text(
                'Convert your voice into tasks instantly and efficiently — perfect for boosting your daily productivity.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 80.h),
              buildCustomButton(
                () => showModalBottomSheet(
                  backgroundColor: ColorStyle.white,
                  showDragHandle: true,
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => AuthBottomSheet(type: "Login"),
                ),
                "Login",
                ColorStyle.primary,
                ColorStyle.light,
              ),
              // const SizedBox(height: 10),
              // buildCustomButton(
              //   () => showModalBottomSheet(
              //     backgroundColor: ColorStyle.white,
              //     context: context,
              //     isScrollControlled: true,
              //     showDragHandle: true,
              //     shape: const RoundedRectangleBorder(
              //       borderRadius:
              //           BorderRadius.vertical(top: Radius.circular(20)),
              //     ),
              //     builder: (_) => AuthBottomSheet(type: "Register"),
              //   ),
              //   "Register",
              //   ColorStyle.light,
              //   ColorStyle.dark,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
