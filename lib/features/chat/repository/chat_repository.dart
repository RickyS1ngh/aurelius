import 'package:aurelius/core/constants/constants.dart';
import 'package:aurelius/core/failure.dart';
import 'package:aurelius/core/providers/firebase_providers.dart';
import 'package:aurelius/core/typedef.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

final chatRepositoryProvider =
    Provider((ref) => ChatRepository(ref.read(firestoreProvider)));

class ChatRepository {
  const ChatRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<ChatMessage?> getResponse(
    List<Map<String, dynamic>> messageHistory,
    ChatUser currentUser,
    ChatUser aureliusBot,
    OpenAI openAI,
  ) async {
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
          text: i.message!.content,
        );
      }
    }

    return ChatMessage(
      user: aureliusBot,
      createdAt: DateTime.now(),
      text: 'Try Again!',
    );
  }

  EitherChatMessages<List<ChatMessage>> uploadMessageHistory(
    List<ChatMessage> allMessages,
    ChatMessage newBotResponse,
    String userUid,
  ) async {
    try {
      final chatBox = await _getChatBox();

      final storedMessages = [...allMessages];
      storedMessages.insert(0, newBotResponse);

      await chatBox.clear();
      for (int i = 0; i < storedMessages.length; i++) {
        await chatBox.put(i, storedMessages[i]);
      }

      await _firestore.collection(Constants.chatCollection).doc(userUid).set({
        'chat': storedMessages
            .map((chat) => {
                  'text': chat.text,
                  'user': {
                    'id': chat.user.id,
                    'firstName': chat.user.firstName,
                    'lastName': chat.user.lastName,
                  },
                  'createdAt': chat.createdAt.toIso8601String(),
                })
            .toList()
      });

      return right(storedMessages);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Box<ChatMessage>> _getChatBox() async {
    if (!Hive.isBoxOpen(Constants.chatBox)) {
      return await Hive.openBox<ChatMessage>(Constants.chatBox);
    }
    return Hive.box<ChatMessage>(Constants.chatBox);
  }

  bool isCachedUser() {
    if (Hive.isBoxOpen(Constants.chatBox)) {
      final box = Hive.box<ChatMessage>(Constants.chatBox);
      return box.isNotEmpty;
    }
    return false;
  }

  List<ChatMessage> loadCachedUser() {
    if (Hive.isBoxOpen(Constants.chatBox)) {
      final box = Hive.box<ChatMessage>(Constants.chatBox);
      return box.values.toList();
    }
    return [];
  }
}
