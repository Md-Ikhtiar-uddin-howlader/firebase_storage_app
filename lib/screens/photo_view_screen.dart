import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class PhotoViewScreen extends StatefulWidget {
  final String imagePath;

  PhotoViewScreen({required this.imagePath, Key? key}) : super(key: key);

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  String imageUrl = '';
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    try {
      // Get the reference to the photo in Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child(widget.imagePath);

      // Get the download URL for the image
      imageUrl = await storageReference.getDownloadURL();

      // Force a rebuild to display the image
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _logger.e('Error loading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo View'),
      ),
      body: Center(
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
