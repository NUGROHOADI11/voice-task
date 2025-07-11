import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_task/utils/services/firestore_service.dart';
import '../../../utils/services/notification_service.dart';
import '../../task/models/task_model.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.put(DashboardController());

  final isSearching = false.obs;
  final selectedDateIndex = RxnInt();
  final searchController = TextEditingController();
  final selectedDate = Rxn<DateTime>();
  final _allTasks = <Task>[].obs;
  final activeTasks = <Task>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  StreamSubscription? _taskSubscription;

  @override
  void onInit() {
    super.onInit();
    _streamTasks();
    ever(selectedDate, (_) => _filterTasks());
  }

  @override
  void onClose() {
    _taskSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      _filterTasks();
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

  void _streamTasks() {
    // isLoading(true);
    _taskSubscription = FirestoreService().getDataTask().listen((snapshot) {
      final tasks = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Task.fromMap(data, doc.id);
      }).toList();

      _allTasks.value = tasks;
      _filterTasks();
      _setNotification();
      isLoading.value = false;
    }, onError: (error) {
      errorMessage.value = "Failed to load tasks: $error";
      log("Failed to load tasks: $error");
      isLoading.value = false;
    });
  }

  void _filterTasks() {
    final date = selectedDate.value;
    if (date == null) {
      activeTasks.assignAll(_allTasks);
      return;
    }

    final filtered = _allTasks.where((task) {
      final start = task.startDate;
      final end = task.dueDate;

      if (start == null || end == null) return false;

      final normalizedDate = DateTime(date.year, date.month, date.day);
      final normalizedStart = DateTime(start.year, start.month, start.day);
      final normalizedEnd = DateTime(end.year, end.month, end.day);

      return normalizedDate.isAtSameMomentAs(normalizedStart) ||
          normalizedDate.isAtSameMomentAs(normalizedEnd) ||
          (normalizedDate.isAfter(normalizedStart) &&
              normalizedDate.isBefore(normalizedEnd));
    }).toList();

    activeTasks.value = filtered;
  }

  void _setNotification() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final tasksForTomorrow = _allTasks.where((task) {
      final start = task.startDate;
      if (start == null) return false;

      return start.year == tomorrow.year &&
          start.month == tomorrow.month &&
          start.day == tomorrow.day;
    }).toList();

    if (tasksForTomorrow.isNotEmpty) {
      final notificationService = NotificationService();
      final String title = 'Upcoming Tasks Reminder'.tr;
      final String body =
          'You have ${tasksForTomorrow.length} task(s) scheduled for tomorrow.'
              .tr;

      notificationService.scheduleNotification(
        id: 99,
        title: title,
        body: body,
        scheduledTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9),
      );
    }
  }
}
