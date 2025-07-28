import 'package:hive_ce/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final int? colorValue;
  @HiveField(4)
  final bool isPin;
  @HiveField(5)
  final bool? isHidden;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime? updatedAt;
  @HiveField(8)
  final List<String> tags;
  @HiveField(9)
  bool isSynced = false;
  @HiveField(10)
  bool isDeleted = false;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.colorValue,
    this.isPin = false,
    this.isHidden,
    DateTime? createdAt,
    this.updatedAt,
    this.tags = const [],
    this.isSynced = false,
    this.isDeleted = false,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Note.fromMap(Map<String, dynamic> map, String documentId) {
    if (map['title'] == null || map['content'] == null) {
      throw const FormatException(
          "Missing required fields in map for Note: title, content");
    }
    return Note(
      id: documentId,
      title: map['title'] as String,
      content: map['content'] ?? '[]',
      colorValue: map['colorValue'] as int?,
      isPin: map['isPin'] ?? false,
      isHidden: map['isHidden'] as bool?,
      isSynced: map['isSynced'] as bool? ?? false,
      isDeleted: map['isDeleted'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      tags: (map['tags'] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'colorValue': colorValue,
      'isPin': isPin,
      'isHidden': isHidden,
      'isSynced': isSynced,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tags': tags,
    };
  }

  factory Note.fromUpdate({
    required Note originalNote,
    required Map<String, dynamic> updateData,
  }) {
    return Note(
      id: originalNote.id,
      title: updateData['title'] as String? ?? originalNote.title,
      content: updateData['content'] as String? ?? originalNote.content,
      colorValue: updateData.containsKey('colorValue')
          ? updateData['colorValue'] as int?
          : originalNote.colorValue,
      isPin: updateData.containsKey('isPin')
          ? updateData['isPin']
          : originalNote.isPin,
      isHidden: updateData.containsKey('isHidden')
          ? updateData['isHidden'] as bool?
          : originalNote.isHidden,
      isSynced: updateData.containsKey('isSynced')
          ? updateData['isSynced'] as bool
          : originalNote.isSynced,
      isDeleted: updateData.containsKey('isDeleted')
          ? updateData['isDeleted'] as bool
          : originalNote.isDeleted,
      createdAt: originalNote.createdAt,
      updatedAt: DateTime.now(),
      tags: updateData.containsKey('tags')
          ? (updateData['tags'] as List<dynamic>?)
                  ?.map((tag) => tag.toString())
                  .toList() ??
              originalNote.tags
          : originalNote.tags,
    );
  }
}
