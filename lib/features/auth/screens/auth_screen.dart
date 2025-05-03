import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
            onPressed: () {},
            label: const Text(
              'Continue with Google',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            icon: Image.asset(
              'assets/images/google_logo.png',
              height: 40,
            ),
          ),
        )
      ]),
    );
  }
}
