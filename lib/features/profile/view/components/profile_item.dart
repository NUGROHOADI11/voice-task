import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildProfileItem({
  required IconData icon,
  required String title,
  String? subtitle,
  required VoidCallback onTap,
  bool showDivider = true,
  bool showTrailing = true,
}) {
  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0.w),
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle?.isNotEmpty == true ? Text(subtitle!) : null,
        trailing: showTrailing ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
      if (showDivider) const Divider(height: 1, color: Colors.grey),
    ],
  );
}
