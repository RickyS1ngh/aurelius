import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ModalInputScreen extends StatefulWidget {
  const ModalInputScreen(this.message, {super.key});

  final void Function(String) message;

  @override
  State<ModalInputScreen> createState() => _ModalInputScreenState();
}

final _textController = TextEditingController();

class _ModalInputScreenState extends State<ModalInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.black),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Write to Aurelius',
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
                onPressed: () {
                  widget.message(_textController.text);
                  _textController.clear();
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ))
          ]),
        )
      ]),
    );
  }
}
