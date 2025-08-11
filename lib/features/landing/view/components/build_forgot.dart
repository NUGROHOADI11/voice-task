import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';
import '../../controllers/landing_controller.dart';
import 'build_input.dart';

Widget buildForgotPasswordForm(
  BuildContext context,
  RxBool isForgot,
) {

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Reset Password",
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        "Enter your registered email address and we'll send you a reset link.",
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      const SizedBox(height: 20),
      buildInput("Email", controller: LandingController.to.emailTextController),
      const SizedBox(height: 20),
      Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: LandingController.to.isLoading.value
                  ? null
                  : () async {
                      await _resetPassword(
                        LandingController.to.emailTextController.text.trim(),
                        isForgot,
                      );
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: ColorStyle.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Send Reset Link",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )),
      TextButton(
        onPressed: () {
          isForgot.value = false;
        },
        child: const Text(
          "Back to Login",
          style: TextStyle(color: ColorStyle.primary),
        ),
      ),
    ],
  );
}

Future<void> _resetPassword(String email, RxBool isForgot) async {
  if (email.isEmpty || !GetUtils.isEmail(email)) {
    _showErrorDialog('Please enter a valid email address');
    return;
  }

  LandingController.to.isLoading.value = true;
  try {
    await LandingController.to.auth.sendPasswordResetEmail(email: email);
    Get.defaultDialog(
      title: "Success".tr,
      middleText: "We've sent a password reset link to: $email".tr,
      onConfirm: () {
        Get.back();
        isForgot.value = false;
      },
      textConfirm: "OK".tr,
    );
  } catch (e) {
    _showErrorDialog('Password reset failed: $e');
  } finally {
    LandingController.to.isLoading.value = false;
  }
}

void _showErrorDialog(String message) {
  Get.defaultDialog(
    title: "Error",
    middleText: message,
    textConfirm: "OK",
    onConfirm: () => Get.back(),
  );
}
