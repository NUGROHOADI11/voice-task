import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/styles/color_style.dart';
import '../../../shared/widgets/custom_datepicker.dart';
import '../../../utils/services/firestore_service.dart';
import '../../task/models/task_model.dart';

class DetailTaskController extends GetxController {
  static DetailTaskController get to => Get.put(DetailTaskController());

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = true.obs;
  final RxString startDate = ''.obs;
  final RxString dueDate = ''.obs;
  final Rxn<int> selectedColor = Rxn<int>();
  final status = TaskStatus.pending.obs;
  final priority = TaskPriority.medium.obs;
  final Rxn<Task> task = Rxn<Task>();

  final FirestoreService _firestoreService = FirestoreService();
  late String taskId;

  @override
  void onInit() {
    super.onInit();
    taskId = Get.arguments['taskId'];
    fetchTaskDetails(taskId);
  }

  Future<void> fetchTaskDetails(String taskId) async {
    try {
      isLoading.value = true;
      final DocumentSnapshot docSnapshot =
          await _firestoreService.getTaskDocument(taskId);
      if (docSnapshot.exists && docSnapshot.data() != null) {
        task.value = Task.fromMap(
            docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);

        titleController.text = task.value?.title ?? '';
        subtitleController.text = task.value?.subtitle ?? '';
        descriptionController.text = task.value?.description ?? '';
        selectedColor.value = task.value?.colorValue;
        startDate.value = task.value?.startDate ?? '';
        dueDate.value = task.value?.dueDate ?? '';
        status.value = task.value!.status;
        priority.value = task.value!.priority;
      } else {
        Get.snackbar(
          "Error",
          "Task not found.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        task.value = null;
      }
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
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      startDate.value = _formatDate(pickedDate);

      if (dueDate.value.isNotEmpty) {
        final due = DateTime.tryParse(dueDate.value);
        if (due != null && pickedDate.isAfter(due)) {
          dueDate.value = '';
        }
      }
    }
  }

  Future<void> pickDueDate(BuildContext context) async {
    DateTime initial = DateTime.now();

    if (startDate.value.isNotEmpty) {
      final start = DateTime.tryParse(startDate.value);
      if (start != null && initial.isBefore(start)) {
        initial = start;
      }
    }

    final pickedDate = await buildDatePicker(
      context: context,
      initialDate: initial,
      minDate: startDate.value.isNotEmpty
          ? DateTime.tryParse(startDate.value)
          : DateTime(2000),
    );

    if (pickedDate != null) {
      final start = DateTime.tryParse(startDate.value);
      if (start != null && pickedDate.isBefore(start)) {
        Get.snackbar('Invalid Date', 'Due date cannot be before start date.');
        return;
      }
      dueDate.value = _formatDate(pickedDate);
    }
  }

  String _formatDate(DateTime date) => date.toIso8601String().split('T').first;

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
        'colorValue': selectedColor.value ?? task.value!.colorValue,
        'priority': priority.value.name,
        'startDate': startDate.value.isEmpty ? null : startDate.value,
        'dueDate': dueDate.value.isEmpty ? null : dueDate.value,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firestoreService.updateTask(taskId, updateData);
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
