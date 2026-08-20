import 'package:app/utils/utils.dart';
import 'package:app/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _postController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance.ref('Post');
  bool _isLoading = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _addPost() async {
    if (_postController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    final String id = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await _databaseRef.child(id).set({
        'title': _postController.text.trim(),
        'id': id,
      });
      Utils().toastMessage('Post added');
      _postController.clear();
    } catch (error) {
      Utils().toastMessage(error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Post')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: _postController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What is on your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            RoundButton(
              title: 'Add',
              loading: _isLoading,
              onTap: _addPost,
            ),
          ],
        ),
      ),
    );
  }
}