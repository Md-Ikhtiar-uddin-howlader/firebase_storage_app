import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoUploadScreen extends StatelessWidget {
  final picker = ImagePicker();

  Future<void> _uploadPhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('photos/${DateTime.now()}.png');
      await storageReference.putFile(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Photo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _uploadPhoto,
          child: Text('Upload Photo'),
        ),
      ),
    );
  }
}