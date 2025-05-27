import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final openAIProvider = Provider((ref) {
  return OpenAI.instance.build(
      token: dotenv.env['OPEN_AI_API_KEY'] ?? '',
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 15),
      ),
      enableLog: true);
});
