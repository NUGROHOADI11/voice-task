import 'package:flutter/material.dart';

Widget buildCustomButton(controller, text, color, textColor) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: controller,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
