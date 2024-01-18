import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class PhotoViewScreen extends StatefulWidget {
  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  List<String> imagePaths = []; // List to store image paths
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadImagePaths();
  }

  Future<void> _loadImagePaths() async {
    try {
      // Get references to all photos in Firebase Storage
      ListResult result =
          await FirebaseStorage.instance.ref().child('photos').list();

      // Extract image paths from the result
      result.items.forEach((Reference ref) {
        imagePaths.add(ref.fullPath);
      });

      // Force a rebuild to display the images
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _logger.e('Error loading image paths: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo View'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // You can adjust the number of columns
        ),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: InkWell(
              onTap: () {
                // You can handle the tap if needed
              },
              child: FutureBuilder<String>(
                future: getImageUrl(imagePaths[index]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String> getImageUrl(String imagePath) async {
    // Get the download URL for the image
    return await FirebaseStorage.instance
        .ref()
        .child(imagePath)
        .getDownloadURL();
  }
}
