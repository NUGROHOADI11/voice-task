import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/styles/color_style.dart';
import '../../../shared/widgets/custom_datepicker.dart';
import '../../task/controllers/task_controller.dart';
import '../../task/models/task_model.dart';
import '../../task/repositories/task_repository.dart';

class DetailTaskController extends GetxController {
  static DetailTaskController get to => Get.put(DetailTaskController());
  final taskRepo = TaskRepository();
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = true.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> dueDate = Rx<DateTime?>(null);
  final Rxn<int> selectedColor = Rxn<int>();
  final status = TaskStatus.pending.obs;
  final priority = TaskPriority.medium.obs;
  final Rxn<Task> task = Rxn<Task>();

  late String taskId;

  @override
  void onInit() {
    super.onInit();
    taskId = Get.arguments['taskId'];
    log('Task ID: $taskId');
    fetchTaskDetails(taskId);
  }

  Future<void> fetchTaskDetails(String taskId) async {
    try {
      isLoading.value = true;

      final localTask = taskRepo.getTaskById(taskId);
      if (localTask != null) {
        task.value = localTask;
      }

      titleController.text = task.value?.title ?? '';
      subtitleController.text = task.value?.subtitle ?? '';
      descriptionController.text = task.value?.description ?? '';
      selectedColor.value = task.value?.colorValue;
      startDate.value = task.value?.startDate;
      dueDate.value = task.value?.dueDate;
      status.value = task.value!.status;
      priority.value = task.value!.priority;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch task details: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      task.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTaskDetails(String taskId) async {
    await fetchTaskDetails(taskId);
  }

  Future<void> pickStartDate(BuildContext context) async {
    final pickedDate = await buildDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
    );

    if (pickedDate != null) {
      startDate.value = pickedDate;

      if (dueDate.value != null && pickedDate.isAfter(dueDate.value!)) {
        dueDate.value = null;
      }
    }
  }

  Future<void> pickDueDate(BuildContext context) async {
    final pickedDate = await buildDatePicker(
      context: context,
      initialDate: dueDate.value ?? startDate.value ?? DateTime.now(),
      minDate: startDate.value,
    );

    if (pickedDate != null) {
      dueDate.value = pickedDate;
    }
  }

  Future<void> updateTask() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Update Task"),
        content: const Text("Are you sure you want to update this task?"),
        actions: [
          TextButton(
            onPressed: () {
              fetchTaskDetails(taskId);
              Get.back(result: false);
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style:
                ElevatedButton.styleFrom(backgroundColor: ColorStyle.success),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      isLoading.value = true;

      final updateData = {
        'title': titleController.text.trim(),
        'subtitle': subtitleController.text.trim().isEmpty
            ? null
            : subtitleController.text.trim(),
        'description': descriptionController.text.trim(),
        'status': status.value.name,
        'colorValue': selectedColor.value,
        'priority': priority.value.name,
        'startDate': startDate.value,
        'dueDate': dueDate.value,
      };

      await taskRepo.updateTask(taskId, updateData);
      TaskController.to.fetchTasks();
      log('Updating task in local storage: $updateData');

      Get.back();
      Get.snackbar(
        "Success",
        "Task updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      await fetchTaskDetails(taskId);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update task: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
