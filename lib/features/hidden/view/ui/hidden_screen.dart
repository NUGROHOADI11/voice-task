import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../../../constants/core/assets/image_constant.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../task/controllers/task_controller.dart';

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
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: IconButton(
                  icon: const Icon(Icons.unarchive),
                  onPressed: () {
                    taskController.hideTask(task.id!, task.title, hide: false);
                  },
                ),
              onTap: () {
                Get.toNamed(Routes.detailTaskRoute,
                    arguments: {'taskId': task.id});
              },
              ),
            );
          },
        );
      }),
    );
  }
}
