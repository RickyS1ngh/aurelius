import 'package:aurelius/adapters/category_adapter.dart';
import 'package:aurelius/adapters/chatMessage_adapter.dart';
import 'package:aurelius/adapters/reflection_adapter.dart';
import 'package:aurelius/adapters/task_adapter.dart';
import 'package:aurelius/adapters/user_adapter.dart';

import 'package:aurelius/core/constants/constants.dart';
import 'package:aurelius/core/providers/firebase_providers.dart';
import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/auth/screens/auth_screen.dart';
import 'package:aurelius/features/chat/controller/chat_controller.dart';
import 'package:aurelius/features/splash/screens/splash_screen.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ReflectionAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ChatMessageAdapter());

  await Hive.openBox(Constants.userBox);

  try {
    await Hive.openBox<ChatMessage>(Constants.chatBox);
  } catch (_) {}

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: StreamBuilder(
        stream: ref.watch(authProvider).authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (ref.read(currentUserProvider) == null) {
              if (ref.read(authControllerProvider.notifier).isCachedUser()) {
                Future.microtask(() {
                  ref.read(authControllerProvider.notifier).loadCachedUser();

                  if (ref
                      .read(chatControllerProvider.notifier)
                      .isCachedChat()) {
                    ref.read(chatControllerProvider.notifier).loadCachedChat();
                  }
                });
              }
            }
            return const SplashScreen();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
