import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_task/shared/styles/color_style.dart';
import '../../../../configs/routes/route.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../controllers/task_controller.dart';
import '../components/task_tile.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});
  final controller = TaskController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: Text('Task'.tr),
          isSearch: controller.isSearching.value ? true : false,
          onSearchChanged: controller.isSearching.value
              ? (value) => controller.searchQuery.value = value
              : null,
          action: !controller.isSearching.value
              ? IconButton(
                  onPressed: controller.toggleSearch,
                  icon: const Icon(Icons.search))
              : IconButton(
                  onPressed: () {
                    controller.toggleSearch();
                  },
                  icon: const Icon(Icons.close),
                ),
          action2: !controller.isSearching.value
              ? IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.taskAddTaskRoute);
                  },
                  icon: const Icon(Icons.add))
              : null,
        ),
        body: Obx(() {
          final allTasks = controller.tasks
              .where((t1) => t1.isDeleted == false)
              .where((t2) => t2.title
                  .toLowerCase()
                  .contains(controller.searchQuery.value.toLowerCase()))
              .where((t3) => t3.isHidden == false)
              .toList();
          allTasks.sort((a, b) => a.title.compareTo(b.title));
          allTasks.sort((a, b) {
            if (a.isPin && !b.isPin) {
              return -1;
            } else if (!a.isPin && b.isPin) {
              return 1;
            }
            return a.title.compareTo(b.title);
          });

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return allTasks.isEmpty
              ? Center(
                  child: Text(
                    'No tasks found.'.tr,
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
                        : ColorStyle.grey;

                    return buildTaskTile(
                        taskId: taskId,
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
                          log('Navigating to task details for $taskId');
                          Get.toNamed(
                            Routes.detailTaskRoute,
                            arguments: {'taskId': taskId},
                          );
                        },
                        onComplete: () async {
                          final removedTask = controller.tasks[index];
                          controller.tasks.removeAt(index);
                          try {
                            await controller.completeTask(task.id!);
                          } catch (e) {
                            log('Complete error: $e');
                            controller.tasks.insert(index, removedTask);
                          }
                        },
                        onDelete: () async {
                          final removedTask = controller.tasks[index];
                          controller.tasks.removeAt(index);
                          try {
                            await controller.deleteTask(task.id!);
                          } catch (e) {
                            log('Delete error: $e');
                            controller.tasks.insert(index, removedTask);
                          }
                        },
                        onHold: true,
                      );
                  },
                );
        }),
      ),
    );
  }
}
