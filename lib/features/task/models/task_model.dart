import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 3)
enum TaskStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  completed,

  @HiveField(3)
  onHold,

  @HiveField(4)
  outDate;

  static TaskStatus fromString(String? statusString) {
    return values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => TaskStatus.pending,
    );
  }
}

@HiveType(typeId: 4)
enum TaskPriority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high;

  static TaskPriority fromString(String? priorityString) {
    return values.firstWhere(
      (e) => e.name == priorityString,
      orElse: () => TaskPriority.medium,
    );
  }
}

@HiveType(typeId: 2)
class Task {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? subtitle;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final TaskStatus status;
  @HiveField(5)
  final DateTime? startDate;
  @HiveField(6)
  final DateTime? dueDate;
  @HiveField(7)
  final TaskPriority priority;
  @HiveField(8)
  final bool isPin;
  @HiveField(9)
  final bool isHidden;
  @HiveField(10)
  final int? colorValue;
  @HiveField(11)
  final String? attachmentUrl;
  @HiveField(12)
  final DateTime createdAt;
  @HiveField(13)
  final DateTime? updatedAt;
  @HiveField(14)
  bool isSynced = false;
  @HiveField(15)
  bool isDeleted = false;

  Task({
    this.id,
    required this.title,
    this.subtitle,
    required this.description,
    this.status = TaskStatus.pending,
    this.startDate,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.isPin = false,
    this.isHidden = false,
    this.colorValue,
    this.attachmentUrl,
    this.isSynced = false,
    this.isDeleted = false,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date);
    return null;
  }

  factory Task.fromMap(Map<String, dynamic> map, String documentId) {
    return Task(
      id: documentId,
      title: map['title'] ?? '',
      subtitle: map['subtitle'],
      description: map['description'] ?? '',
      status: TaskStatus.fromString(map['status']),
      startDate: _parseDate(map['startDate']),
      dueDate: _parseDate(map['dueDate']),
      priority: TaskPriority.fromString(map['priority']),
      isPin: map['isPin'] ?? false,
      isHidden: map['isHidden'] ?? false,
      colorValue: map['colorValue'],
      attachmentUrl: map['attachmentUrl'],
      isSynced: map['isSynced'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'status': status.name,
      'startDate': startDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.name,
      'isPin': isPin,
      'isHidden': isHidden,
      'colorValue': colorValue,
      'attachmentUrl': attachmentUrl,
      'isSynced': isSynced,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Task.fromUpdate({
    required Task originalTask,
    required Map<String, dynamic> updateData,
  }) {
    return Task(
      id: originalTask.id,
      title: updateData['title'] ?? originalTask.title,
      subtitle: updateData.containsKey('subtitle')
          ? updateData['subtitle']
          : originalTask.subtitle,
      description: updateData['description'] ?? originalTask.description,
      status: updateData.containsKey('status')
          ? TaskStatus.fromString(updateData['status'])
          : originalTask.status,
      startDate: updateData.containsKey('startDate')
          ? updateData['startDate']
          : originalTask.startDate,
      dueDate: updateData.containsKey('dueDate')
          ? updateData['dueDate']
          : originalTask.dueDate,
      priority: updateData.containsKey('priority')
          ? TaskPriority.fromString(updateData['priority'])
          : originalTask.priority,
      isPin: updateData.containsKey('isPin')
          ? updateData['isPin']
          : originalTask.isPin,
      isHidden: updateData.containsKey('isHidden')
          ? updateData['isHidden']
          : originalTask.isHidden,
      isSynced: updateData.containsKey('isSynced')
          ? updateData['isSynced'] as bool
          : originalTask.isSynced,
      isDeleted: updateData.containsKey('isDeleted')
          ? updateData['isDeleted'] as bool
          : originalTask.isDeleted,
      colorValue: updateData.containsKey('colorValue')
          ? updateData['colorValue']
          : originalTask.colorValue,
      attachmentUrl: updateData.containsKey('attachmentUrl')
          ? updateData['attachmentUrl']
          : originalTask.attachmentUrl,
      createdAt: originalTask.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}