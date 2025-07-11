import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_task/shared/styles/color_style.dart';
import '../../../../configs/routes/route.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../controllers/task_controller.dart';
import '../components/task_tile.dart';
import '../../models/task_model.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});
  final controller = TaskController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
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
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.searchQuery.isEmpty
                          ? Icons.task_alt_rounded
                          : Icons.search_off_rounded,
                      size: 80.sp,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      controller.searchQuery.isEmpty
                          ? 'No tasks yet'.tr
                          : 'No results found'.tr,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      controller.searchQuery.isEmpty
                          ? 'Add a task to get started'.tr
                          : 'Try a different keyword or check your filters.'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (controller.searchQuery.isEmpty)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorStyle.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.taskAddTaskRoute);
                        },
                        child: Text('Add Task'.tr),
                      ),
                  ],
                ),
              );
            }

            final visibleTasks = controller.filteredTasks
                .where((task) => task.isHidden == false)
                .toList();

            return ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: visibleTasks.length,
              itemBuilder: (context, index) {
                final Task task = visibleTasks[index];
                final String taskId = task.id ?? '';
                Color tileColor = task.colorValue != null
                    ? Color(task.colorValue!)
                    : ColorStyle.grey;

                return GestureDetector(
                  onLongPress: () {
                    _showOptionsDialog(context, taskId, index, visibleTasks);
                  },
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
                  ),
                );
              },
            );
          }),
        ));
  }

  void _showOptionsDialog(
      BuildContext context, String taskId, int index, List<Task> visibleTasks) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hidden Task'.tr),
          content: Text('Are you sure you want to hide this task?'.tr),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'.tr,
                  style: const TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hide'.tr, style: const TextStyle(color: Colors.red)),
              onPressed: () {
                controller.hideTask(taskId, visibleTasks[index].title);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
