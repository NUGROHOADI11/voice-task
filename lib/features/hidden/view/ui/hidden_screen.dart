import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../../../constants/core/assets/image_constant.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../task/controllers/task_controller.dart';
import '../../../task/view/components/task_tile.dart';

class HiddenScreen extends StatelessWidget {
  HiddenScreen({super.key});

  final TaskController taskController = TaskController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: Text('Hidden'),
      ),
      body: Obx(() {
        final hiddenTasks = taskController.allTasks
            .where((task) => task.isHidden == true)
            .toList();

        log(hiddenTasks.length.toString());
        log('Hidden tasks: ${hiddenTasks.map((task) => task.title).join(', ')}');

        if (taskController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (hiddenTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImageConstant.homeDecoration,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Hidden Tasks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: hiddenTasks.length,
          itemBuilder: (context, index) {
            final task = hiddenTasks[index];
            String taskId = task.id!;
            final tileColor =
                task.colorValue != null ? Color(task.colorValue!) : Colors.grey;
            return buildTaskTile(
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
            );
          },
        );
      }),
    );
  }
}
