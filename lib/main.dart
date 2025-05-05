import 'package:aurelius/core/providers/firebase_providers.dart';
import 'package:aurelius/features/auth/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
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
                return Placeholder();
              } else {
                return AuthScreen();
              }
            }));
  }
}
