import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voice_task/configs/routes/route.dart';
import 'package:voice_task/shared/styles/color_style.dart';
import 'package:voice_task/features/task/view/components/task_tile.dart';
import 'package:voice_task/features/dashboard/controllers/dashboard_controller.dart';
import 'pin_card.dart';

Widget buildTaskList() {
  final controller = DashboardController.to;

  return Obx(() {
    if (controller.selectedDate.value == null) {
      return buildPinList();
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return Center(child: Text(controller.errorMessage.value));
    }

    if (controller.activeTasks.isEmpty) {
      return Center(
        child: Text(
          'No active tasks on ${DateFormat('MMM dd, yyyy').format(controller.selectedDate.value!)}'
              .tr,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.activeTasks.length,
      itemBuilder: (context, index) {
        final task = controller.activeTasks[index];

        String taskId = task.id!;
        final tileColor =
            task.colorValue != null ? Color(task.colorValue!) : ColorStyle.grey;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w,),
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
              Get.toNamed(Routes.detailTaskRoute,
                  arguments: {'taskId': taskId});
            },
          ),
        );
      },
    );
  });
}
