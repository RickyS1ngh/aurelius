import 'package:aurelius/features/chat/controller/chat_controller.dart';
import 'package:aurelius/features/chat/screens/modal_input_screen.dart';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagesProvider =
    StateProvider<List<ChatMessage>>((ref) => <ChatMessage>[]);

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ChatUser _currentUser = ChatUser(
      id: FirebaseAuth.instance.currentUser!.uid,
      firstName: FirebaseAuth.instance.currentUser!.displayName);
  final ChatUser _aureliusBot = ChatUser(
    id: '2',
    firstName: 'Marcus',
    lastName: 'Aurelius',
  );
  String? messageText;
  ChatMessage? chatMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              messageOptions: const MessageOptions(
                  currentUserContainerColor: Color(0xffe3e0cd),
                  textColor: Color(0xFFa68a64)),
              inputOptions: const InputOptions(
                inputDisabled: true, // default
                inputToolbarPadding: EdgeInsets.zero,
                inputDecoration: InputDecoration.collapsed(hintText: ''),
                inputTextStyle: TextStyle(fontSize: 0),
              ),

              // ),
              currentUser: _currentUser,
              onSend: (_) {},
              messages: ref.watch(messagesProvider),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .80,
                child: TextField(
                  readOnly: true,
                  showCursor: false,
                  autofocus: false,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .45,
                              child: ModalInputScreen(
                                (text) {
                                  messageText = text;
                                  chatMessage = ChatMessage(
                                      user: _currentUser,
                                      text: messageText!,
                                      createdAt: DateTime.now());
                                  ref
                                      .read(chatControllerProvider.notifier)
                                      .getReponse(chatMessage!, _currentUser,
                                          _aureliusBot);
                                },
                              ),
                            ),
                          );
                        });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Tap to speak to Aurelius',
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ))
            ]),
          )
        ],
      ),
    );
  }
}
