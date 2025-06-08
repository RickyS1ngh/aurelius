import 'package:aurelius/models/reflection.dart';
import 'package:hive_ce/hive.dart';

class ReflectionAdapter extends TypeAdapter<ReflectionModel> {
  @override
  final int typeId = 6;

  @override
  ReflectionModel read(BinaryReader reader) {
    final title = reader.readString();
    final text = reader.readString();
    final rawTimestamp = reader.readInt();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(rawTimestamp);
    final uuid = reader.readString();
    return ReflectionModel(
        title: title, text: text, uuid: uuid, createdAt: createdAt);
  }

  @override
  void write(BinaryWriter writer, ReflectionModel obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.text);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeString(obj.uuid);
  }
}
