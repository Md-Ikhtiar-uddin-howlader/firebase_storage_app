import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoUploadScreen extends StatefulWidget {
  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final picker = ImagePicker();
  bool isUploading = false;

  Future<void> _uploadPhoto(ImageSource source) async {
    setState(() {
      isUploading = true;
    });

    try {
      final pickedFile = await picker.getImage(source: source);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Get the current timestamp for unique file names
        DateTime now = DateTime.now();
        String fileName = 'photos/${now}.png';

        // Create a reference to the file in Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child(fileName);

        // Get the file's content type
        String contentType =
            'image/png'; // You can use image_picker's mimeType property

        // Create metadata for the file
        SettableMetadata metadata = SettableMetadata(contentType: contentType);

        // Upload the file with metadata
        await storageReference.putFile(imageFile, metadata);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Photo uploaded successfully!'),
        ));
      }
    } catch (e) {
      print('Error uploading photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading photo. Please try again.'),
      ));
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  isUploading ? null : () => _uploadPhoto(ImageSource.camera),
              child: isUploading
                  ? CircularProgressIndicator()
                  : Text('Take a Photo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  isUploading ? null : () => _uploadPhoto(ImageSource.gallery),
              child: isUploading
                  ? CircularProgressIndicator()
                  : Text('Choose from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
