import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 23;

  @override
  ChatMessage read(BinaryReader reader) {
    try {
      final firstName = reader.readString();
      final lastName = reader.readString();
      final userID = reader.readString();
      final text = reader.readString();
      final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

      return ChatMessage(
        user: ChatUser(id: userID, firstName: firstName, lastName: lastName),
        text: text,
        createdAt: createdAt,
      );
    } catch (e) {
      return ChatMessage(
        user: ChatUser(id: 'error', firstName: 'Error', lastName: 'Error'),
        text: 'This message is not able to be loaded.',
        createdAt: DateTime.now(),
      );
    }
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer.writeString(obj.user.firstName ?? '');
    writer.writeString(obj.user.lastName ?? '');
    writer.writeString(obj.user.id);
    writer.writeString(obj.text);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
