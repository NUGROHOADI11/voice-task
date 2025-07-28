import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/services/notification_service.dart';
import '../../task/models/task_model.dart';
import '../../task/repositories/task_repository.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  final isSearching = false.obs;
  final selectedDateIndex = RxnInt();
  final searchController = TextEditingController();
  final selectedDate = Rxn<DateTime>();
  final activeTasks = <Task>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final TaskRepository _taskRepo = TaskRepository();

  @override
  void onInit() {
    super.onInit();
    _loadTasks();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
    }
  }

  void selectDate(int index, DateTime date) {
    if (selectedDateIndex.value == index) {
      clearSelectedDate();
    } else {
      selectedDateIndex.value = index;
      selectedDate.value = date;
    }
  }

  void clearSelectedDate() {
    selectedDateIndex.value = null;
    selectedDate.value = null;
  }

  void _loadTasks() {
    try {
      final allTasks = _taskRepo.getAllTasks();
      isLoading.value = false;
      _setNotification(allTasks);
    } catch (e) {
      errorMessage.value = 'Failed to load tasks: $e';
      isLoading.value = false;
    }
  }

  void _setNotification(List<Task> allTasks) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final tasksForTomorrow = allTasks.where((task) {
      final start = task.startDate;
      if (start == null) return false;
      return start.year == tomorrow.year &&
          start.month == tomorrow.month &&
          start.day == tomorrow.day;
    }).toList();

    if (tasksForTomorrow.isNotEmpty) {
      NotificationService().scheduleNotification(
        id: 99,
        title: 'Upcoming Tasks Reminder'.tr,
        body:
            'You have ${tasksForTomorrow.length} task(s) scheduled for tomorrow.'
                .tr,
        scheduledTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9),
      );
    }
  }
}
