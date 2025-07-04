import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/styles/color_style.dart';

import '../../../../shared/widgets/quill_viewer.dart';

Widget buildNoteCard({
  required String title,
  required String content,
  required String time,
  required String date,
  required Color backgroundColor,
  required VoidCallback onPinButtonPressed,
  required bool isPinned,
  required VoidCallback onTap,
}) {
  final bool isDark = backgroundColor == ColorStyle.primary ||
      backgroundColor == ColorStyle.dark ||
      backgroundColor == Colors.black;

  final Color textColor = isDark ? Colors.white : Colors.black;
  final Color subColor = isDark ? Colors.white70 : Colors.grey.shade800;
  final Color dateColor = isDark ? Colors.white60 : Colors.black54;

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
              ),
              InkWell(
                onTap: onPinButtonPressed,
                child: Icon(
                  isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 18.h,
                  color: textColor,
                ),
              )
            ],
          ),
          const SizedBox(height: 6),
          IgnorePointer(
            child: QuillViewer(
              jsonString: content,
              defaultTextStyle: TextStyle(color: textColor, overflow: TextOverflow.ellipsis, ),
            ),
          ),
          const SizedBox(height: 8),
          Text(time, style: TextStyle(color: subColor)),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(date,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: dateColor)),
          ),
        ],
      ),
    ),
  );
}
