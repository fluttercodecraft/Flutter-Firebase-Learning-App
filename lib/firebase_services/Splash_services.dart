import 'dart:async';
import 'package:app/ui/auth/login_screen.dart';
import 'package:app/ui/firebase_firestore/fire_store_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    Timer(const Duration(seconds: 3), () {
      if (!context.mounted) return;

      final targetScreen = user != null
          ? const ShowFireStorePostScreen()
          : const LoginScreen();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => targetScreen),
            (route) => false,
      );
    });
  }
}