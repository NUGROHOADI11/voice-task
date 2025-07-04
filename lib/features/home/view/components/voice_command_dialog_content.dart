import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../constants/core/assets/image_constant.dart';

class VoiceCommandDialogContent extends StatelessWidget {
  final HomeController controller;

  const VoiceCommandDialogContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h, left: 5.w, right: 5.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close, size: 24.w),
                  onPressed: () {
                    controller.stopListening();
                    Navigator.pop(context);
                    controller.activityDetected();
                  },
                ),
                Text(
                  'VoiceTask',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() => controller.isLoadingAI.value
                    ? const CircularProgressIndicator()
                    :  SizedBox(
                      width: 48.w,
                    ))
              ],
            ),
          ),
          Container(
            height: 300.h,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Obx(() => Text(
                          controller.recognizedWords.value.isEmpty &&
                                  controller.isListening.value
                              ? 'Listening...'
                              : controller.recognizedWords.value.isNotEmpty
                                  ? controller.recognizedWords.value
                                  : (controller.speechEnabled.value
                                      ? 'Say something'.tr
                                      : 'Tap to speak'.tr),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize:
                                controller.recognizedWords.value.isNotEmpty
                                    ? 16.sp
                                    : 14.sp,
                            fontWeight:
                                controller.recognizedWords.value.isNotEmpty
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                          ),
                        )),
                  ),
                  const Spacer(),
                  Obx(() => Text(
                        controller.sttStatus.value.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: controller.speechEnabled.value
                              ? Colors.black
                              : Colors.red,
                        ),
                      )),
                  if (controller.recognizedWords.value.isEmpty &&
                      controller.isListening.value) ...[
                    SizedBox(height: 4.h),
                    Text(
                      '"Open my notes"'.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  SizedBox(height: 20.h),
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        controller.toggleMicAndDetectActivity();
                      },
                      child: Container(
                        height: 65.w,
                        width: 65.w,
                        decoration: BoxDecoration(
                          color: controller.isListening.value
                              ? ColorStyle.secondary
                              : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(18.r),
                        child: Image.asset(
                          ImageConstant.logoApk,
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
