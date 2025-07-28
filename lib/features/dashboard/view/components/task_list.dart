import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voice_task/configs/routes/route.dart';
import 'package:voice_task/shared/styles/color_style.dart';
import 'package:voice_task/features/dashboard/controllers/dashboard_controller.dart';
import '../../../task/controllers/task_controller.dart';
import '../../../task/view/components/task_tile.dart';
import 'pin_card.dart';

Widget buildTaskList() {
  final controller = DashboardController.to;
  final taskController = TaskController.to;

  return Obx(() {
    final _ = taskController.tasks.length;

    final selectedDate = controller.selectedDate.value;

    if (selectedDate == null) {
      return buildPinList();
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return Center(child: Text(controller.errorMessage.value));
    }

    final tasks = taskController.getTasksByDate(selectedDate);

    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No active tasks on ${DateFormat('MMM dd, yyyy').format(selectedDate)}'
              .tr,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      key: ValueKey(tasks.length),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final tileColor =
            task.colorValue != null ? Color(task.colorValue!) : ColorStyle.grey;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: buildTaskTile(
            taskId: task.id!,
            title: task.title,
            task: task,
            desc: task.description,
            startDate: task.startDate,
            dueDate: task.dueDate,
            status: task.status.name,
            priority: task.priority.name,
            isPinned: task.isPin,
            backgroundColor: tileColor,
            attachmentUrl: task.attachmentUrl,
            onTap: () {
              log('Navigating to task details for ${task.id}');
              Get.toNamed(
                Routes.detailTaskRoute,
                arguments: {'taskId': task.id},
              );
            },
            onComplete: () async {
              final removedTask =
                  taskController.tasks.firstWhereOrNull((t) => t.id == task.id);
              taskController.tasks.removeWhere((t) => t.id == task.id);
              try {
                await taskController.completeTask(task.id!);
              } catch (e) {
                log('Complete error: $e');
                if (removedTask != null) {
                  taskController.tasks.add(removedTask);
                }
              }
            },
            onDelete: () async {
              final removedTask =
                  taskController.tasks.firstWhereOrNull((t) => t.id == task.id);
              taskController.tasks.removeWhere((t) => t.id == task.id);
              try {
                await taskController.deleteTask(task.id!);
              } catch (e) {
                log('Delete error: $e');
                if (removedTask != null) {
                  taskController.tasks.add(removedTask);
                }
              }
            },
          ),
        );
      },
    );
  });
}
