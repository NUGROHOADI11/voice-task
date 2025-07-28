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

    for (var task in tasks) {
      try {
        if (task.isDeleted) {
          if (task.id != null) {
            await FirestoreService().deleteTask(task.id!);
          }
          await _taskBox.delete(task.id);
          continue;
        }

        final taskMap = task.toMap();
        taskMap.remove('isSynced');
        taskMap.remove('isDeleted');

        await FirestoreService().addTask(taskMap, docId: task.id);

        final updatedTask = Task.fromUpdate(
          originalTask: task,
          updateData: {
            'updatedAt': DateTime.now(),
            'isSynced': true,
          },
        );
        await _taskBox.put(task.id, updatedTask);
      } catch (e) {
        log("Failed to sync task ${task.id}: $e");
      }
    }
  }

  Future<void> syncTasksFromFirebase() async {
    final snapshot = await FirestoreService().getDataTask().first;
    for (var doc in snapshot.docs) {
      final task = Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      await addTask(task);
    }
  }

  Future<void> addTask(Task task) async {
    task.id ??= DateTime.now().millisecondsSinceEpoch.toString();
    task = Task.fromUpdate(originalTask: task, updateData: {
      'isSynced': false,
      'updatedAt': DateTime.now(),
    });
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(String id, Map<String, dynamic> updateData) async {
  final existingTask = _taskBox.get(id);
  if (existingTask != null) {
    final updatedTask = Task.fromUpdate(
      originalTask: existingTask,
      updateData: {
        ...updateData,
        'isSynced': false,
        'updatedAt': DateTime.now(),
      },
    );
    await _taskBox.put(id, updatedTask);
  } else {
    throw Exception('Task with id $id not found');
  }
}


  Future<void> deleteTask(String id) async {
    final task = _taskBox.get(id);
    if (task != null) {
      final markedTask = Task.fromUpdate(originalTask: task, updateData: {
        'isDeleted': true,
        'isSynced': false,
        'updatedAt': DateTime.now(),
      });
      await _taskBox.put(id, markedTask); 
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

  List<Task> getTasksByDate(DateTime date) {
    return _taskBox.values.where((task) {
      if (task.startDate == null || task.dueDate == null) return false;
      return task.startDate!.isBefore(date) && task.dueDate!.isAfter(date);
    }).toList();
  }

  // List<Task> getTasksByDate(DateTime date) {
  //   return _taskBox.values.where((task) {
  //     if (task.startDate == null) {
  //       return false;
  //     }
  //     // Compare year, month, and day to ignore time
  //     return task.startDate!.year == date.year &&
  //         task.startDate!.month == date.month &&
  //         task.startDate!.day == date.day;
  //   }).toList();
  // }

  Stream<List<Task>> watchTasks() {
    return _taskBox.watch().map((event) {
      return _taskBox.values.toList();
    });
  }
}
