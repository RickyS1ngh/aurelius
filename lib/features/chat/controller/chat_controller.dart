import 'package:aurelius/core/providers/openAI_provider.dart';
import 'package:aurelius/features/chat/repository/chat_repository.dart';
import 'package:aurelius/features/chat/screens/chat_screen.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider =
    StateNotifierProvider<ChatController, ChatMessage>((ref) {
  return ChatController(ref.read(chatRepositoryProvider), ref);
});

class ChatController extends StateNotifier<ChatMessage> {
  ChatController(ChatRepository chatRepository, Ref ref)
      : _chatRepository = chatRepository,
        _ref = ref,
        super(ChatMessage(
          user: ChatUser(id: ''),
          createdAt: DateTime.now(),
        ));
  final ChatRepository _chatRepository;
  final Ref _ref;

  Future<void> getReponse(
      ChatMessage message, ChatUser currentUser, ChatUser aureliusBot) async {
    final previousMessages = _ref.read(messagesProvider);
    final prompt = Messages(
        role: Role.system,
        content:
            'You are Marcus Aurelius. Please respond to the user with their questions as Aurelius would, offering wisdom as well as guidance . Be encouraging as well. Short messages of length of 4-5 sentences');
    _ref.read(messagesProvider.notifier).state = [message, ...previousMessages];

    final messageHistory = [
      prompt,
      ..._ref.read(messagesProvider).reversed.map((message) {
        if (message.user == currentUser) {
          return Messages(role: Role.user, content: message.text);
        } else {
          return Messages(role: Role.assistant, content: message.text);
        }
      })
    ];

    final List<Map<String, dynamic>> messageHistoryMap =
        messageHistory.map((m) => m.toJson()).toList();
    final responseMessage = await _chatRepository.getReponse(
        messageHistoryMap, currentUser, aureliusBot, _ref.read(openAIProvider));

    _ref.read(messagesProvider).insert(0, responseMessage!);
  }
}
