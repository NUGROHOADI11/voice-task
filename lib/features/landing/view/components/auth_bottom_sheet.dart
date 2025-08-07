import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_task/constants/core/assets/icon_constant.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_textfield.dart';
import '../../controllers/landing_controller.dart';

class AuthBottomSheet extends StatelessWidget {
  final String type;
  final _controller = LandingController.to;

  AuthBottomSheet({super.key, required this.type});

  bool get isLogin => type == "Login";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLogin ? "Login" : "Sign Up",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isLogin
                  ? "It's ritual time! Login and let's get all"
                  : "We are so excited you're ready to become a part of our journey!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            if (!isLogin) ...[
              _buildInput("Username",
                  controller: _controller.usernameTextController),
              const SizedBox(height: 10),
            ],
            _buildInput("Email", controller: _controller.emailTextController),
            const SizedBox(height: 10),
            _buildInput(
              "Password",
              isPassword: true,
              controller: _controller.passwordTextController,
              isPasswordVisible: _controller.isPassword,
              onTogglePassword: _controller.togglePasswordVisibility,
              onChanged: (value) => _controller.validatePassword(),
            ),
            const SizedBox(height: 10),
            if (!isLogin) ...[
              _buildPasswordValidationBar(),
            ],
            const SizedBox(height: 10),
            if (!isLogin)
              _buildInput("Confirm Password",
                  isPassword: true,
                  controller: _controller.confirmPasswordTextController,
                  isPasswordVisible: _controller.isConfirmPassword,
                  onTogglePassword:
                      _controller.toggleConfirmPasswordVisibility),
            const SizedBox(height: 30),
            _buildMainButton(context),
            _buildBottomText(context),
            const SizedBox(height: 20),
            if (isLogin) _buildDividerWithText(),
            _buildSocialButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationRow(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.grey.shade600,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.grey.shade700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordValidationBar() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildValidationRow(
                "At least 8 characters", _controller.hasMin8Chars.value),
            const SizedBox(height: 4),
            _buildValidationRow(
                "Contains an uppercase & lowercase letter",
                _controller.hasUppercase.value &&
                    _controller.hasLowercase.value),
            const SizedBox(height: 4),
            _buildValidationRow(
                "Contains a symbol (!@#\$...)", _controller.hasSymbol.value),
          ],
        ));
  }

  Widget _buildInput(
    String label, {
    bool isPassword = false,
    TextEditingController? controller,
    RxBool? isPasswordVisible,
    VoidCallback? onTogglePassword,
    void Function(String)? onChanged,
  }) {
    if (!isPassword) {
      return CustomTextField(
        label: label,
        hintText: 'Type your ${label.toLowerCase()}',
        isPassword: false,
        controller: controller,
        keyboardType: label.toLowerCase() == 'email'
            ? TextInputType.emailAddress
            : TextInputType.text,
      );
    }

    return Obx(() {
      return CustomTextField(
        label: label,
        hintText: 'Type your ${label.toLowerCase()}',
        isPassword: true,
        controller: controller,
        obscureText: isPasswordVisible?.value ?? true,
        onTogglePassword: onTogglePassword,
        onChanged: onChanged,
      );
    });
  }

  Widget _buildMainButton(BuildContext context) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _controller.isLoading.value
                ? null
                : () async {
                    if (isLogin) {
                      if (_controller.isLoginFormValid) {
                        await _controller.login(
                          _controller.emailTextController.text.trim(),
                          _controller.passwordTextController.text.trim(),
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
                      if (_controller.isSignupFormValid) {
                        await _controller.signup(
                          _controller.emailTextController.text.trim(),
                          _controller.passwordTextController.text.trim(),
                          _controller.confirmPasswordTextController.text.trim(),
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
              isLogin ? "Login" : "Register",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }

  Widget _buildBottomText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          isLogin ? "Don't have an account?" : "Already have an account?",
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showModalBottomSheet(
              backgroundColor: ColorStyle.white,
              showDragHandle: true,
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) =>
                  AuthBottomSheet(type: isLogin ? "Register" : "Login"),
            );
          },
          child: Text(isLogin ? "Sign Up" : "Sign In",
              style: const TextStyle(
                color: ColorStyle.primary,
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
    );
  }

  Widget _buildDividerWithText() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text("or", style: TextStyle(color: Colors.grey.shade600)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildSocialButton(
          "Sign in with Google",
          Colors.white,
          Colors.black,
          imageAsset: IconConstant.google,
          onPressed: () async {
            await _controller.googleSignIn();
          },
        ),
        const SizedBox(height: 10),
        _buildSocialButton(
          "Sign in with Apple",
          Colors.black,
          Colors.white,
          imageAsset: IconConstant.apple,
          isIconWhite: true,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    String text,
    Color bgColor,
    Color textColor, {
    String? imageAsset,
    bool isIconWhite = false,
    VoidCallback? onPressed,
  }) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _controller.isLoading.value ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Colors.black12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageAsset != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ColorFiltered(
                      colorFilter: isIconWhite
                          ? const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            )
                          : const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.multiply,
                            ),
                      child: Image.asset(
                        imageAsset,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
