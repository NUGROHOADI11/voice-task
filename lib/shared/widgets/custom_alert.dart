import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlert {
  static void show({
    required String title,
    required String message,
    Color backgroundColor = Colors.red,
    IconData icon = Icons.error_outline,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  static void error(String message) {
    show(
      title: 'Error',
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
    );
  }

  static void warning(String message) {
    show(
      title: 'Warning',
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void success(String message) {
    show(
      title: 'Success',
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }
}
