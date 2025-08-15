import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.find();
  final taskRepo = TaskRepository();

  var tasks = <Task>[].obs;
  var isLoading = true.obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  late StreamSubscription _taskSubscription;
  final RxInt _taskUpdateTrigger = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();

    debounce<int>(_taskUpdateTrigger, (_) {
      fetchTasks();
    }, time: const Duration(milliseconds: 500));

    _taskSubscription = taskRepo.watchTasks().listen((event) {
      log("Task updated (debounce): $event");
      _taskUpdateTrigger.value++;
    });
  }

  void fetchTasks() {
    try {
      isLoading.value = true;
      tasks.value = taskRepo.getAllTasks();
    } catch (e) {
      log("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
    }
  }

  Future<void> completeTask(String taskId) async {
    try {
      await taskRepo.updateTask(taskId, {
        'status': TaskStatus.completed.name,
      });

      log('Updating status in local storage: $taskId');
      fetchTasks();
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<void> hideTask(String taskId, Task task) async {
    try {
      await taskRepo.updateTask(taskId, {
        'isHidden': !task.isHidden,
      });
      fetchTasks();
      Get.snackbar(
        task.isHidden ? 'Task Hidden'.tr : 'Task Unhidden'.tr,
        '"${task.title}" has been ${task.isHidden ? 'hidden' : 'unhidden'}'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: task.isHidden ? Colors.orangeAccent : Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to update task: ${e.toString()}'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await taskRepo.deleteTask(taskId);
      Get.back();
      log('Deleting task from local storage: $taskId');
    } catch (e) {
      log("Error deleting task: $e");

      fetchTasks();
    }
  }

  Future<void> togglePinStatus(String taskId, Task task) async {
    try {
      await taskRepo.updateTask(taskId, {
        'isPin': !task.isPin,
      });

      fetchTasks();
      log('Updating pin status in local storage: $taskId');
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to update pin status: ${e.toString()}'.tr,
        snackPosition: SnackPosition.TOP,
      );
      log('Error updating pin status: $e');
    }
  }

  List<Task> getTasksByDate(DateTime date) {
    return taskRepo.getTasksByDate(date);
  }

  Map<String, dynamic> getStatusStyle(String status, Color defaultColor) {
    status = status.toLowerCase();
    if (status.contains('pending')) {
      return {
        'icon': Icons.hourglass_empty_outlined,
        'color': Colors.orange.shade700
      };
    } else if (status.contains('progress')) {
      return {'icon': Icons.sync_outlined, 'color': Colors.blue.shade700};
    } else if (status.contains('completed') || status.contains('done')) {
      return {
        'icon': Icons.check_circle_outline,
        'color': Colors.green.shade700
      };
    }
    return {'icon': Icons.info_outline, 'color': defaultColor};
  }

  Map<String, dynamic> getPriorityStyle(String priority, Color defaultColor) {
    priority = priority.toLowerCase();
    if (priority.contains('high')) {
      return {'icon': Icons.flag_rounded, 'color': Colors.red.shade700};
    } else if (priority.contains('medium')) {
      return {'icon': Icons.flag_rounded, 'color': Colors.amber.shade800};
    } else if (priority.contains('low')) {
      return {
        'icon': Icons.outlined_flag_rounded,
        'color': Colors.teal.shade700
      };
    }
    return {'icon': Icons.label_important_outline, 'color': defaultColor};
  }

  @override
  void onClose() {
    super.onClose();
    _taskSubscription.cancel();
  }
}
