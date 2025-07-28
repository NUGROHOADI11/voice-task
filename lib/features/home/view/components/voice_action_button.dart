import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../constants/core/assets/image_constant.dart';

class VoiceActionButton extends StatelessWidget {
  final HomeController controller;
  final double initialFabBottomPosition;
  final double navBarHiddenOffset;
  final double fabHeight;
  final VoidCallback onPressed;
  final bool isDisabled;

  const VoiceActionButton({
    super.key,
    required this.controller,
    required this.initialFabBottomPosition,
    required this.navBarHiddenOffset,
    required this.fabHeight,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        bottom: controller.isNavBarVisible.value
            ? initialFabBottomPosition
            : initialFabBottomPosition - navBarHiddenOffset - fabHeight,
        left: MediaQuery.of(context).size.width / 2 - (fabHeight / 2),
        child: Container(
          padding: const EdgeInsets.all(18),
          height: fabHeight,
          width: fabHeight,
          decoration: BoxDecoration(
            color: isDisabled ? ColorStyle.grey : ColorStyle.secondary,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(fabHeight / 2),
            child: Image.asset(
              ImageConstant.logoApk,
            ),
          ),
        ),
      );
    });
  }
}
