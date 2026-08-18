import 'package:flutter/material.dart';
class SplashScree extends StatefulWidget {
  const SplashScree({super.key});

  @override
  State<SplashScree> createState() => _SplashScreeState();
}

class _SplashScreeState extends State<SplashScree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Firebase App'),
        ),
        body: const Center(
          child: Text('Firebase Connected!',style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ),
    );
  }
}
