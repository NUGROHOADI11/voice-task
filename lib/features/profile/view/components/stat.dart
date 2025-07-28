import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../note/controllers/note_controller.dart';
import '../../../task/controllers/task_controller.dart';

Widget buildStats() {
  return SizedBox(
    height: 80,
    child: Row(
      children: [
        _buildStatCard(
            'Notes'.tr,
            NoteController.to.notes
                .where((p0) => !p0.isDeleted)
                .length
                .toString(),
            ColorStyle.primary,
            ColorStyle.white,
            flex: 4),
        SizedBox(width: 8.w),
        _buildStatCard(
            'Tasks'.tr,
            TaskController.to.tasks
                .where((p0) => !p0.isDeleted)
                .length
                .toString(),
            ColorStyle.accent,
            ColorStyle.black,
            flex: 3),
        SizedBox(width: 8.w),
        _buildStatCard(
          'Back Up'.tr,
          (() {
            final totalItems =
                NoteController.to.notes.length + TaskController.to.tasks.length;
            if (totalItems == 0) return 'no data';
            final syncedNotes =
                NoteController.to.notes.where((p0) => p0.isSynced).length;
            final syncedTasks =
                TaskController.to.tasks.where((p0) => p0.isSynced).length;
            final syncedPercentage =
                ((syncedNotes + syncedTasks) / totalItems * 100).round();
            return '$syncedPercentage%';
          })(),
          ColorStyle.secondary,
          ColorStyle.black,
          flex: 4,
        ),
      ],
    ),
  );
}

Widget _buildStatCard(String label, String value, Color color, textColor,
    {required int flex}) {
  return Expanded(
    flex: flex,
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          Text(value, style: TextStyle(color: textColor)),
        ],
      ),
    ),
  );
}
