import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

import '../../../configs/routes/route.dart';
import '../../../shared/controllers/global_controller.dart';
import '../../note/repositories/note_repository.dart';
import '../../note/sub_features/add_note/models/note_model.dart';
import '../../task/models/task_model.dart';
import '../../task/repositories/task_repository.dart';

class OfflineController extends GetxController {
  static OfflineController get to => Get.find();
  final isLoading = false.obs;
  final isOnline = GlobalController.to.isConnected.value;
  var notes = <Note>[].obs;
  var tasks = <Task>[].obs;
  var banner = true.obs;

  void toggleBanner() {
    banner.value = !banner.value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchOfflineData();
  }

  void fetchOfflineData() {
    try {
      isLoading.value = true;
      notes.value = NoteRepository().getAllNotes();
      tasks.value = TaskRepository().getAllTasks();
    } catch (e) {
      log("Error fetching offline data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void refreshConnection() {
    isLoading.value = true;
    try {
      if (isOnline) {
        Get.offAllNamed(Routes.splashRoute);
      } else {
        Get.snackbar("Error", "No internet connection",
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to refresh connection: $e",
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }
}
