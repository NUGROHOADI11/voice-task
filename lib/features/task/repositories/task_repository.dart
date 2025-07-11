import 'dart:developer';

import 'package:hive_ce/hive.dart';

import '../../../utils/services/firestore_service.dart';
import '../constants/task_api_constant.dart';
import '../models/task_model.dart';

class TaskRepository {
  TaskRepository._internal();
  static final TaskRepository _instance = TaskRepository._internal();
  factory TaskRepository() => _instance;

  var apiConstant = TaskApiConstant();
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  Future<void> syncTasksToFirebase() async {
    final tasks = _taskBox.values.toList();
    if (tasks.isEmpty) return;

    for (var task in tasks) {
      try {
        await FirestoreService().addTask(task.toMap());
        await _taskBox.clear();
      } catch (e) {
        log("Failed to sync task ${task.id}: $e");
      }
    }
  }

  Future<void> addTask(Task task) async {
    if (task.id == null || task.id!.isEmpty) {
      task.id = DateTime.now().millisecondsSinceEpoch.toString();
    }
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    if (_taskBox.containsKey(id)) {
      await _taskBox.put(id, updatedTask);
    } else {
      throw Exception('Task with id $id not found');
    }
  }

  Future<void> deleteTask(String id) async {
    if (_taskBox.containsKey(id)) {
      await _taskBox.delete(id);
    } else {
      throw Exception('Task with id $id not found');
    }
  }
  Future<void> deleteAllTasks() async {
    await _taskBox.clear();
    }

  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }

  Task? getTaskById(String id) {
    return _taskBox.get(id);
  }
}
