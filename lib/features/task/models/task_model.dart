enum TaskStatus {
  pending,
  inProgress,
  completed,
  onHold,
  outDate;

  static TaskStatus fromString(String? statusString) {
    return values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => TaskStatus.pending,
    );
  }
}

enum TaskPriority {
  low,
  medium,
  high;

  static TaskPriority fromString(String? priorityString) {
    return values.firstWhere(
      (e) => e.name == priorityString,
      orElse: () => TaskPriority.medium,
    );
  }
}

class Task {
  String? id;
  final String title;
  final String? subtitle;
  final String description;
  final TaskStatus status;
  final String? startDate;
  final String? dueDate;
  final TaskPriority priority;
  final bool isPin;
  final bool isHidden;
  final int? colorValue;
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

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
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Task.fromMap(Map<String, dynamic> map, String documentId) {
    return Task(
      id: documentId,
      title: map['title'] ?? '',
      subtitle: map['subtitle'],
      description: map['description'] ?? '',
      status: TaskStatus.fromString(map['status']),
      startDate: map['startDate'],
      dueDate: map['dueDate'],
      priority: TaskPriority.fromString(map['priority']),
      isPin: map['isPin'] ?? false,
      isHidden: map['isHidden'] ?? false,
      colorValue: map['colorValue'],
      attachmentUrl: map['attachmentUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'status': status.name,
      'startDate': startDate,
      'dueDate': dueDate,
      'priority': priority.name,
      'isPin': isPin,
      'isHidden': isHidden,
      'colorValue': colorValue,
      'attachmentUrl': attachmentUrl,
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
