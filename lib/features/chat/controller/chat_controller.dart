import 'package:aurelius/core/providers/openAI_provider.dart';
import 'package:aurelius/core/utils.dart';
import 'package:aurelius/features/chat/repository/chat_repository.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagesProvider =
    StateProvider<List<ChatMessage>>((ref) => <ChatMessage>[]);

final chatControllerProvider =
    StateNotifierProvider<ChatController, ChatMessage>((ref) {
  return ChatController(ref.read(chatRepositoryProvider), ref);
});

class ChatController extends StateNotifier<ChatMessage> {
  ChatController(this._chatRepository, this._ref)
      : super(ChatMessage(user: ChatUser(id: ''), createdAt: DateTime.now()));

  final ChatRepository _chatRepository;
  final Ref _ref;

  Future<void> getResponse(
    BuildContext context,
    ChatMessage userMessage,
    ChatUser currentUser,
    ChatUser aureliusBot,
    String userID,
  ) async {
    final updatedMessages = [userMessage, ..._ref.read(messagesProvider)];
    _ref.read(messagesProvider.notifier).state = updatedMessages;

    final prompt = Messages(
      role: Role.system,
      content:
          'You are Marcus Aurelius. Please respond to the user with their questions as Aurelius would, offering wisdom as well as guidance. Be encouraging as well. Short messages of 4-5 sentences.',
    );

    final messageHistory = [
      prompt,
      ...updatedMessages.reversed.map((msg) {
        return msg.user.id == currentUser.id
            ? Messages(role: Role.user, content: msg.text)
            : Messages(role: Role.assistant, content: msg.text);
      }),
    ];

    final List<Map<String, dynamic>> messageHistoryMap =
        messageHistory.map((m) => m.toJson()).toList();

    final response = await _chatRepository.getResponse(
      messageHistoryMap,
      currentUser,
      aureliusBot,
      _ref.read(openAIProvider),
    );

    final newBotMessage = ChatMessage(
      user: aureliusBot,
      text: response?.text ?? 'Try Again!',
      createdAt: DateTime.now(),
    );

    final chatHistory = await _chatRepository.uploadMessageHistory(
      updatedMessages,
      newBotMessage,
      userID,
    );

    chatHistory.fold(
      (l) => showSnackbar(context, l.errorMessage),
      (chat) => _ref.read(messagesProvider.notifier).state = chat,
    );
  }

  bool isCachedChat() {
    return _chatRepository.isCachedUser();
  }

  void loadCachedChat() {
    try {
      final cached = _chatRepository.loadCachedUser();
      _ref.read(messagesProvider.notifier).state = cached;
    } catch (_) {}
  }
}
