import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/core/assets/icon_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/landing_controller.dart';
import 'build_divider.dart';
import 'build_input.dart';
import 'build_social.dart';

Widget buildAuthForm(BuildContext context, RxBool isLogin, RxBool isForgot) {
  final controller = LandingController.to;
  return Column(
    children: [
      if (!isLogin.value) ...[
        buildInput("Username", controller: controller.usernameTextController),
        const SizedBox(height: 10),
      ],
      buildInput("Email", controller: controller.emailTextController),
      const SizedBox(height: 10),
      buildInput(
        "Password",
        isPassword: true,
        controller: controller.passwordTextController,
        isPasswordVisible: controller.isPassword,
        onTogglePassword: controller.togglePasswordVisibility,
        onChanged: (value) => controller.validatePassword(),
      ),
      if (!isLogin.value) ...[
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  "Password must contain:",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                _buildPasswordValidationRow(
                    "At least 8 characters", controller.hasMin8Chars.value),
                _buildPasswordValidationRow(
                    "An uppercase letter", controller.hasUppercase.value),
                _buildPasswordValidationRow(
                    "A lowercase letter", controller.hasLowercase.value),
                _buildPasswordValidationRow(
                    "A symbol", controller.hasSymbol.value),
              ],
            )),
      ],
      const SizedBox(height: 10),
      if (!isLogin.value)
        buildInput(
          "Confirm Password",
          isPassword: true,
          controller: controller.confirmPasswordTextController,
          isPasswordVisible: controller.isConfirmPassword,
          onTogglePassword: controller.toggleConfirmPasswordVisibility,
        ),
      if (isLogin.value)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              isForgot.value = true;
            },
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: ColorStyle.primary),
            ),
          ),
        ),
      const SizedBox(height: 20),
      Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                      if (isLogin.value) {
                        if (controller.isLoginFormValid) {
                          await controller.login(
                            controller.emailTextController.text.trim(),
                            controller.passwordTextController.text.trim(),
                          );
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please fill all fields',
                            backgroundColor: ColorStyle.warning,
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      } else {
                        if (controller.isSignupFormValid) {
                          await controller.signup(
                            controller.emailTextController.text.trim(),
                            controller.passwordTextController.text.trim(),
                            controller.confirmPasswordTextController.text
                                .trim(),
                          );
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please fill all fields',
                            backgroundColor: ColorStyle.warning,
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: ColorStyle.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isLogin.value ? "Login" : "Register",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )),
      const SizedBox(height: 20),
      buildDivider(),
      const SizedBox(height: 20),
      buildSocialButton(
        "Sign in with Google",
        Colors.white,
        Colors.black,
        imageAsset: IconConstant.google,
        onPressed: () async {
          await controller.googleSignIn();
        },
      ),
      const SizedBox(height: 10),
      buildSocialButton(
        "Sign in with Apple",
        Colors.black,
        Colors.white,
        imageAsset: IconConstant.apple,
        isIconWhite: true,
        onPressed: () {},
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isLogin.value
              ? "Don't have an account?"
              : "Already have an account?"),
          TextButton(
            onPressed: () => isLogin.value = !isLogin.value,
            child: Text(
              isLogin.value ? "Sign Up" : "Sign In",
              style: const TextStyle(
                color: ColorStyle.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildPasswordValidationRow(String text, bool isValid) {
  return Row(
    children: [
      Icon(
        isValid ? Icons.check_circle : Icons.cancel,
        color: isValid ? Colors.green : Colors.red,
        size: 16,
      ),
      const SizedBox(width: 6),
      Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isValid ? Colors.green : Colors.red,
        ),
      ),
    ],
  );
}
