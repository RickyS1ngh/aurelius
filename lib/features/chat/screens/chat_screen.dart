import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/chat/controller/chat_controller.dart';
import 'package:aurelius/features/chat/screens/modal_input_screen.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late ChatUser _currentUser;
  final ChatUser _aureliusBot = ChatUser(
    id: '2',
    firstName: 'Marcus',
    lastName: 'Aurelius',
  );

  @override
  void initState() {
    super.initState();
    _currentUser = ChatUser(
      id: FirebaseAuth.instance.currentUser!.uid,
      firstName: FirebaseAuth.instance.currentUser!.displayName,
    );

    Future.microtask(() {
      if (ref.read(chatControllerProvider.notifier).isCachedChat()) {
        ref.read(chatControllerProvider.notifier).loadCachedChat();
      }
    });
  }

  void sendMessage(String text) {
    final newMessage = ChatMessage(
      user: _currentUser,
      text: text,
      createdAt: DateTime.now(),
    );
    ref.read(chatControllerProvider.notifier).getResponse(
          context,
          newMessage,
          _currentUser,
          _aureliusBot,
          ref.read(currentUserProvider)!.uid,
        );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              messageOptions: const MessageOptions(
                currentUserContainerColor: Color(0xffe3e0cd),
                textColor: Color(0xFFa68a64),
              ),
              inputOptions: const InputOptions(
                inputDisabled: true,
                alwaysShowSend: false,
                sendOnEnter: false,
                inputToolbarPadding: EdgeInsets.zero,
                inputDecoration: InputDecoration.collapsed(hintText: ''),
                inputTextStyle: TextStyle(fontSize: 0),
              ),
              currentUser: _currentUser,
              onSend: (_) {},
              messages: messages,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Container(
                          color: Colors.black,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ModalInputScreen(sendMessage),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Tap to speak to Aurelius',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.send, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
