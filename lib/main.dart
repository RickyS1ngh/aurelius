import 'package:aurelius/core/providers/firebase_providers.dart';
import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:aurelius/features/auth/screens/auth_screen.dart';
import 'package:aurelius/features/splash/screens/splash_screen.dart';
import 'package:aurelius/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox('user');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
                Future.microtask(() {
                  ref.read(authControllerProvider.notifier).loadCachedUser();
                });
              }
              return const SplashScreen();
            } else {
              return const AuthScreen();
            }
          }),
    );
  }
}
