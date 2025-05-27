import 'package:aurelius/core/providers/firebase_providers.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider =
    Provider((ref) => ChatRepository(ref.read(firestoreProvider)));

class ChatRepository {
  const ChatRepository(FirebaseFirestore firestore) : _firestore = firestore;
  final FirebaseFirestore _firestore;

  Future<ChatMessage?> getReponse(messageHistory, ChatUser currentUser,
      ChatUser aureliusBot, openAI) async {
    final request = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: messageHistory,
      maxToken: 500,
    );
    final response = await openAI.onChatCompletion(request: request);

    for (var i in response!.choices) {
      if (i.message != null) {
        return ChatMessage(
            user: aureliusBot,
            createdAt: DateTime.now(),
            text: i.message!.content);
      } else {
        return ChatMessage(
            user: aureliusBot, createdAt: DateTime.now(), text: 'Try Again!');
      }
    }
  }

  // Future<void> uploadMessageHistory(){

  // }
}
