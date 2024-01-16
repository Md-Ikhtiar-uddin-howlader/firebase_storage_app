import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  PhotoUploadScreenState createState() => PhotoUploadScreenState();
}

class PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final picker = ImagePicker();
  bool isUploading = false;
  double uploadProgress = 0.0;
  File? imageFile;
  final Logger _logger = Logger();

  void _selectAndPreviewImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          uploadProgress =
              0.0; // Reset upload progress when selecting a new image
        });
      }
    } catch (e) {
      _logger.e('Error selecting photo: $e');
    }
  }

  Future<void> _uploadPhoto(ScaffoldMessengerState scaffoldMessenger) async {
    if (imageFile == null) {
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text('Please select a photo before uploading.'),
      ));
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      // Get the current timestamp for unique file names
      DateTime now = DateTime.now();
      String fileName = 'photos/$now.png';

      // Create a reference to the file in Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);

      // Get the file's content type
      String contentType =
          'image/png'; // You can use image_picker's mimeType property

      // Create metadata for the file
      SettableMetadata metadata = SettableMetadata(contentType: contentType);

      // Create a new upload task
      UploadTask uploadTask = storageReference.putFile(imageFile!, metadata);

      // Listen to the task completion and update the progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Wait for the upload to complete
      await uploadTask.whenComplete(() {
        _logger.d('Photo uploaded successfully!');
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Photo uploaded successfully!'),
        ));
      });
    } catch (e) {
      _logger.e('Error uploading photo: $e');
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text('Error uploading photo. Please try again.'),
      ));
    } finally {
      setState(() {
        isUploading = false;
        imageFile = null; // Reset imageFile after uploading
      });
    }
  }

  void _cancelPhoto() {
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageFile != null
                    ? Column(
                        children: [
                          Image.file(
                            imageFile!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isUploading
                                ? null
                                : () => _uploadPhoto(
                                    ScaffoldMessenger.of(scaffoldContext)),
                            child: isUploading
                                ? const CircularProgressIndicator()
                                : const Text('Upload File'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isUploading ? null : _cancelPhoto,
                            child: const Text('Cancel Photo'),
                          ),
                        ],
                      )
                    : Container(),
                if (imageFile == null)
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: isUploading
                            ? null
                            : () => _selectAndPreviewImage(ImageSource.camera),
                        child: isUploading
                            ? const CircularProgressIndicator()
                            : const Text('Take a Photo'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isUploading
                            ? null
                            : () => _selectAndPreviewImage(ImageSource.gallery),
                        child: isUploading
                            ? const CircularProgressIndicator()
                            : const Text('Choose from Gallery'),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
