import 'package:app/ui/login_screen.dart';
import 'package:app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InsertFireStoreScreen extends StatefulWidget {
  const InsertFireStoreScreen({super.key});

  @override
  State<InsertFireStoreScreen> createState() => _InsertFireStoreScreenState();
}

class _InsertFireStoreScreenState extends State<InsertFireStoreScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance.collection('users');

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }

  Future<void> _addUser() async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await _fireStore.doc(id).set({
        'full_name': 'John Doe',
        'company': 'Stokes and Sons',
        'age': 25,
        'id': id,
      });
      Utils().toastMessage('Data Added Successfully');
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert Firestore'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: const Center(
        child: Text('Tap the button below to insert new document.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}