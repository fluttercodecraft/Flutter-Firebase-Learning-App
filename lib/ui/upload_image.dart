import 'dart:io';

import 'package:app/utils/utils.dart';
import 'package:app/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;

  File? _image;

  final ImagePicker picker = ImagePicker();

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final DatabaseReference databaseRef =
  FirebaseDatabase.instance.ref('Post');

  // Pick image from gallery
  Future<void> getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image picked');
    }
  }

  // Upload image
  Future<void> uploadImage() async {
    // Check image
    if (_image == null) {
      Utils().toastMessage('Please select an image');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      // Create Firebase Storage reference
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('asiftaj')
          .child(
        DateTime.now().millisecondsSinceEpoch.toString(),
      );

      // Upload image
      final firebase_storage.UploadTask uploadTask =
      ref.putFile(_image!);

      // Wait for upload
      await uploadTask;

      // Get image URL
      final String newUrl = await ref.getDownloadURL();

      // Save URL to Realtime Database
      await databaseRef.child('1').set({
        'id': '1212',
        'title': newUrl,
      });

      Utils().toastMessage('Image uploaded successfully');

      setState(() {
        loading = false;
      });
    } catch (error) {
      Utils().toastMessage(error.toString());

      setState(() {
        loading = false;
      });

      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image picker
            Center(
              child: InkWell(
                onTap: getImageGallery,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Center(
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 39),

            // Upload button
            RoundButton(
              title: 'Upload',
              loading: loading,
              onTap: uploadImage,
            ),
          ],
        ),
      ),
    );
  }
}