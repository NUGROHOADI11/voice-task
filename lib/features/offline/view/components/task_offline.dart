import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../task/view/components/task_tile.dart';
import '../../controllers/offline_controller.dart';

Widget buildOfflineTask() {
  final controller = OfflineController.to;

  final allTasks = controller.tasks;
  return Scaffold(
    backgroundColor: Colors.white,
    body: Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: allTasks.isEmpty
            ? Center(
                child: Text(
                  'No offline tasks found.',
                  style: TextStyle(fontSize: 16.sp),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allTasks.length,
                itemBuilder: (context, index) {
                  final task = allTasks[index];
                  final taskId = task.id ?? 'No ID';
                  final tileColor = task.colorValue != null
                      ? Color(task.colorValue!)
                      : Colors.grey.shade200;

                  return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                      child: buildTaskTile(
                        taskId: taskId,
                        title: task.title,
                        desc: task.description,
                        startDate: task.startDate,
                        dueDate: task.dueDate,
                        status: task.status.name,
                        priority: task.priority.name,
                        isPinned: task.isPin,
                        backgroundColor: tileColor,
                        attachmentUrl: task.attachmentUrl,
                        onTap: () {
                          log('Navigating to task details for $taskId');
                          Get.toNamed(
                            Routes.detailTaskRoute,
                            arguments: {'taskId': taskId},
                          );
                        },
                      ));
                },
              ),
      );
    }),
    floatingActionButton: FloatingActionButton(
      backgroundColor: ColorStyle.primary,
      onPressed: () {
        Get.toNamed(Routes.taskAddTaskRoute);
      },
      child: Icon(Icons.add, size: 30.sp, color: Colors.white),
    ),
  );
}
