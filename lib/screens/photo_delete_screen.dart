import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class PhotoDeleteScreen extends StatefulWidget {
  @override
  _PhotoDeleteScreenState createState() => _PhotoDeleteScreenState();
}

class _PhotoDeleteScreenState extends State<PhotoDeleteScreen> {
  final Logger _logger = Logger();
  List<String> photoFileNames = []; // List to store file names

  @override
  void initState() {
    super.initState();
    // Load the list of photo file names from Firebase Storage
    loadPhotoFileNames();
  }

  Future<void> loadPhotoFileNames() async {
    try {
      // Get a reference to the photos folder in Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('photos');

      // List all items in the folder
      ListResult listResult = await storageReference.list();

      // Extract file names from the items
      photoFileNames = listResult.items.map((item) => item.name).toList();

      // Force a rebuild to update the UI
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _logger.e('Error loading photo file names: $e');
    }
  }

  Future<void> _deletePhoto(String fileName) async {
    try {
      // Show a confirmation dialog before deleting
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Do you really want to delete this photo?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Delete'),
              ),
            ],
          );
        },
      );

      // Check the user's confirmation
      if (confirmDelete == true) {
        // Get the reference to the selected photo in Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child('photos/$fileName');

        // Delete the photo
        await storageReference.delete();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Photo deleted successfully!'),
        ));

        // Reload the list of photo file names after deletion
        loadPhotoFileNames();
      }
    } catch (e) {
      _logger.e('Error deleting photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error deleting photo. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Delete Photo'),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // You can adjust the number of columns
          ),
          itemCount: photoFileNames.length,
          itemBuilder: (context, index) {
            return FutureBuilder<String>(
              future: getImageUrl(photoFileNames[index]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Card(
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        _deletePhoto(photoFileNames[index]);
                      },
                      child: Image.network(
                        snapshot.data!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            );
          },
        ));
  }

  Future<String> getImageUrl(String fileName) async {
    // Get the download URL for the image
    return await FirebaseStorage.instance
        .ref()
        .child('photos/$fileName')
        .getDownloadURL();
  }
}
