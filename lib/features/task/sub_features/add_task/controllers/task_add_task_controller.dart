import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/custom_datepicker.dart';
import '../../../controllers/task_controller.dart';
import '../../../models/task_model.dart';
import '../../../repositories/task_repository.dart';

class TaskAddTaskController extends GetxController {
  static TaskAddTaskController get to => Get.find();

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> dueDate = Rx<DateTime?>(null);

  final selectedStatus = TaskStatus.pending.obs;
  final selectedPriority = TaskPriority.medium.obs;
  final isPin = false.obs;
  final isHidden = false.obs;

  final Rx<File?> attachment = Rx<File?>(null);
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

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

  Future<void> pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;

        final fileSizeKB = file.size / 1024;
        if (fileSizeKB > 5120) {
          Get.snackbar(
            'File too large',
            'Max file size is 5MB',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        attachment.value = File(file.path!);
      }
    } catch (e) {
      log('Error picking file: $e', error: e);
      Get.snackbar('Error', 'Failed to pick file: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void removeAttachment() {
    attachment.value = null;
  }

  void resetForm() {
    titleController.clear();
    subtitleController.clear();
    descriptionController.clear();
    startDate.value = null;
    dueDate.value = null;
    selectedStatus.value = TaskStatus.pending;
    selectedPriority.value = TaskPriority.medium;
    isPin.value = false;
    isHidden.value = false;
    attachment.value = null;
  }

  Future<void> submitTask() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final task = Task(
        title: titleController.text.trim(),
        subtitle: subtitleController.text.trim().isEmpty
            ? null
            : subtitleController.text.trim(),
        description: descriptionController.text.trim(),
        status: selectedStatus.value,
        startDate: startDate.value,
        dueDate: dueDate.value,
        priority: selectedPriority.value,
        isPin: isPin.value,
        isHidden: isHidden.value,
        attachmentUrl: attachment.value?.path,
      );

      log('Submitting task: $task');

      TaskRepository().addTask(task);
      TaskController.to.fetchTasks();
      Get.back();
      Get.back();
      resetForm();
      Get.snackbar('Success', 'Task successfully added');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit task: $e');
      log('Error submitting task: $e', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    subtitleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
