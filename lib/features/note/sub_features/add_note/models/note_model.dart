class Note {
  String? id;
  final String title;
  final String content;
  final int? colorValue;
  final bool isPin;
  final bool? isHidden;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> tags;

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
