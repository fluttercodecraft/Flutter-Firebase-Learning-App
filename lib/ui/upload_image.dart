import 'dart:io';
import 'package:app/utils/utils.dart';
import 'package:app/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  bool _loading = false;

  final _picker = ImagePicker();
  final _databaseRef = FirebaseDatabase.instance.ref('Post');

  Future<void> _getImageGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      Utils().toastMessage('Please select an image');
      return;
    }

    setState(() => _loading = true);

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref('/posts/${DateTime.now().millisecondsSinceEpoch}');

      await ref.putFile(_image!);
      final newUrl = await ref.getDownloadURL();

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await _databaseRef.child(id).set({
        'id': id,
        'title': newUrl,
      });

      Utils().toastMessage('Image uploaded successfully');
      setState(() => _image = null);
    } catch (error) {
      Utils().toastMessage(error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: _getImageGallery,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_image!, fit: BoxFit.cover),
                )
                    : const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
            RoundButton(
              title: 'Upload',
              loading: _loading,
              onTap: _uploadImage,
            ),
          ],
        ),
      ),
    );
  }
}