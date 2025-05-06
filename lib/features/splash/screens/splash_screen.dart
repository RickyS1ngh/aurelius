import 'dart:async';
import 'dart:math';

import 'package:aurelius/data/aurelius_quotes.dart';
import 'package:aurelius/features/tab/screens/tab_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int randomNumber = Random().nextInt(aureliusQuotes.length);
    String quote = aureliusQuotes[randomNumber];
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 200,
          ),
          Image.asset(
            'assets/images/aurelius_logo.png',
            height: 300,
          ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              quote,
              style: const TextStyle(fontFamily: 'Cinzel', fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Marcus Aurelius',
            style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
