import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../utils/services/firestore_service.dart';
import '../../../shared/controllers/global_controller.dart';
import '../../offline/controllers/offline_controller.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.put(TaskController());
  final isOnline = GlobalController.to.isConnected.value;
  final FirestoreService _firestoreService = FirestoreService();

  var allTasks = <Task>[].obs;
  var filteredTasks = <Task>[].obs;
  var isLoading = true.obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    allTasks.bindStream(_getTasksStream());
    ever(allTasks, (_) => _performSearch());
    ever(searchQuery, (_) => _performSearch());
  }

  void removeTask(String taskId) {
    allTasks.removeWhere((task) => task.id == taskId);
  }

  Stream<List<Task>> _getTasksStream() {
    isLoading.value = true;
    return _firestoreService.getDataTask().map((snapshot) {
      try {
        List<Task> tasks = snapshot.docs.map((doc) {
          return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        isLoading.value = false;
        return tasks;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", "Failed to parse tasks: ${e.toString()}",
            snackPosition: SnackPosition.BOTTOM);
        return <Task>[];
      }
    }).handleError((error) {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to fetch tasks: ${error.toString()}",
          snackPosition: SnackPosition.BOTTOM);
      return <Task>[];
    });
  }

  void _performSearch() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredTasks.assignAll(allTasks);
    } else {
      filteredTasks.assignAll(allTasks.where((task) {
        final titleMatch = task.title.toLowerCase().contains(query);
        final descriptionMatch = task.description.toLowerCase().contains(query);
        return titleMatch || descriptionMatch;
      }).toList());
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
    }
  }

  Future<void> completeTask(String taskId, String title) async {
    try {
      if (isOnline) {
        log('Completing task in Firestore: $taskId');
        await _firestoreService.updateTask(taskId, {
          'status': 'completed',
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        TaskRepository().updateTask(taskId, {
          'status': 'completed',
          'updatedAt': DateTime.now().toIso8601String(),
        } as Task);
        OfflineController.to.refreshTasks();
        log('Completing task in local storage: $taskId');
      }
      Get.snackbar(
        'Task Completed'.tr,
        '"$title" marked as complete.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to update task: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> hideTask(String taskId, String title, {bool hide = true}) async {
    try {
      await _firestoreService.updateTask(taskId, {
        'isHidden': hide,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      Get.snackbar(
        hide ? 'Task Hidden'.tr : 'Task Unhidden'.tr,
        '"$title" has been ${hide ? 'hidden' : 'unhidden'}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: hide ? Colors.orangeAccent : Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to update task: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteTask(String taskId, String title,
      {String? attachmentUrl}) async {
    try {
      if (isOnline) {
        if (attachmentUrl != null && attachmentUrl.isNotEmpty) {
          final bucketName = dotenv.env['SUPABASE_BUCKET_NAME']!;
          final storageClient =
              Supabase.instance.client.storage.from(bucketName);
          final publicPath = attachmentUrl.split('/').last;
          final folderPath = 'attachments_task/$publicPath';
          await storageClient.remove([folderPath]);
        }

        await _firestoreService.deleteTask(taskId);
        log('Deleting task in Firestore: $taskId');
      } else {
        log('Deleting task in local storage: $taskId');
        TaskRepository().deleteTask(taskId);
        OfflineController.to.refreshTasks();
      }

      Get.snackbar(
        'Task Deleted'.tr,
        '"$title" was removed.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to delete task: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> togglePinStatus(String taskId, bool isPinned) async {
    try {
      await _firestoreService.updateTask(taskId,
          {'isPin': !isPinned, 'updatedAt': DateTime.now().toIso8601String()});
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to update pin status: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
}
