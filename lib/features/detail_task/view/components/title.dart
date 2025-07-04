import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_task/features/detail_task/controllers/detail_task_controller.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../task/models/task_model.dart';

Widget buildTitleSection(Task task) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          color: task.colorValue != null
              ? Color(task.colorValue!)
              : ColorStyle.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(
          Icons.article_outlined,
          color: (task.colorValue != null
                          ? Color(task.colorValue!)
                          : ColorStyle.primary)
                      .computeLuminance() >
                  0.5
              ? Colors.black
              : Colors.white,
          size: 24,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: DetailTaskController.to.titleController,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Enter Title *'.tr,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
            TextFormField(
              controller: DetailTaskController.to.subtitleController,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'No Subtitle Yet'.tr,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
