  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/custom_textfield.dart';

Widget buildInput(
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