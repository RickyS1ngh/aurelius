import 'dart:io';

import 'package:aurelius/core/utils.dart';
import 'package:aurelius/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const SizedBox(
          height: 100,
        ),
        const Center(
          child: Text(
            'Aurelius',
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 80,
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        Image.asset(
          'assets/images/aurelius_logo.png',
          height: 300,
        ),
        const SizedBox(
          height: 100,
        ),
        SizedBox(
          width: 300,
          child: ElevatedButton.icon(
            onPressed: () async {
              final status = await ref
                  .read(authControllerProvider.notifier)
                  .googleSign(context);
              if (status == false) {
                showSnackbar(context, 'Unable to log in');
              }
            },
            label: const Text(
              'Continue with Google',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            icon: Image.asset(
              'assets/images/google_logo.png',
              height: 40,
            ),
          ),
        ),
        if (Platform.isIOS) ...[
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton.icon(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white)),
              onPressed: () async {
                final status = await ref
                    .read(authControllerProvider.notifier)
                    .appleSignin(context);
                if (status == false) {
                  showSnackbar(context, 'Unable to log in');
                }
              },
              label: const Text('Continue with Apple',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              icon: Image.asset(
                'assets/images/apple_logo.png',
                height: 40,
              ),
            ),
          )
        ]
      ]),
    );
  }
}
