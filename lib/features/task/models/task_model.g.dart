// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 2;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String?,
      title: fields[1] as String,
      subtitle: fields[2] as String?,
      description: fields[3] as String,
      status: fields[4] == null ? TaskStatus.pending : fields[4] as TaskStatus,
      startDate: fields[5] as DateTime?,
      dueDate: fields[6] as DateTime?,
      priority:
          fields[7] == null ? TaskPriority.medium : fields[7] as TaskPriority,
      isPin: fields[8] == null ? false : fields[8] as bool,
      isHidden: fields[9] == null ? false : fields[9] as bool,
      colorValue: (fields[10] as num?)?.toInt(),
      attachmentUrl: fields[11] as String?,
      createdAt: fields[12] as DateTime?,
      updatedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.dueDate)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.isPin)
      ..writeByte(9)
      ..write(obj.isHidden)
      ..writeByte(10)
      ..write(obj.colorValue)
      ..writeByte(11)
      ..write(obj.attachmentUrl)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
