
import 'package:app/ui/inser_fire_store.dart';
import 'package:app/ui/login_screen.dart';
import 'package:app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowFireStorePostScreen extends StatefulWidget {
  const ShowFireStorePostScreen({super.key});

  @override
  State<ShowFireStorePostScreen> createState() => _ShowFireStorePostScreenState();
}

class _ShowFireStorePostScreenState extends State<ShowFireStorePostScreen> {
  final _auth = FirebaseAuth.instance;
  final _usersCollection = FirebaseFirestore.instance.collection('users');

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

  Future<void> _updateUser(String docId) async {
    try {
      await _usersCollection.doc(docId).update({'full_name': 'Asif Taj'});
    } catch (error) {
      Utils().toastMessage('Failed to update: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final id = data['id']?.toString() ?? docs[index].id;

              return ListTile(
                title: Text(data['full_name']?.toString() ?? ''),
                subtitle: Text(data['company']?.toString() ?? ''),
                onTap: () => _updateUser(id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertFireStoreScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}