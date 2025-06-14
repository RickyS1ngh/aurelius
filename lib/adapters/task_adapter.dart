import 'package:aurelius/models/task.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 5;

  @override
  TaskModel read(BinaryReader reader) {
    final title = reader.readString() as String;
    final description = reader.readString() as String;
    final categoryIndex = reader.readInt();
    final category = Category.values[categoryIndex];

    final dueDate = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    final dueHour = reader.readInt();
    final dueMinute = reader.readInt();
    final dueTime = TimeOfDay(hour: dueHour, minute: dueMinute);

    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final isCompleted = reader.readBool();
    final uuid = reader.readString();

    return TaskModel(
      title: title,
      description: description,
      category: category,
      dueDate: dueDate,
      dueTime: dueTime,
      createdAt: createdAt,
      isCompleted: isCompleted,
      uuid: uuid,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.description);

    writer.writeInt(obj.category.index);

    writer.writeInt(obj.dueDate.millisecondsSinceEpoch);

    writer.writeInt(obj.dueTime.hour);
    writer.writeInt(obj.dueTime.minute);

    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeBool(obj.isCompleted);
    writer.writeString(obj.uuid);
  }
}
