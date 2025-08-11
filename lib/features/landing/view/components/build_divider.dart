import 'package:flutter/material.dart';

Widget buildDividerWithText() {
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

Widget buildDivider() {
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
