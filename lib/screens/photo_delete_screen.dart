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
  String selectedFileName = ''; // Selected file name for deletion
  late String selectedImageUrl = '';
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
      ListResult listResult = await storageReference.listAll();

      // Extract file names from the items
      photoFileNames = listResult.items.map((item) => item.name).toList();

      // If there are photos, set the first one as selected
      if (photoFileNames.isNotEmpty) {
        selectedFileName = photoFileNames[0];
        loadSelectedImageUrl();
      }

      setState(() {}); // Force a rebuild to update the UI
    } catch (e) {
      _logger.e('Error loading photo file names: $e');
    }
  }

  Future<void> loadSelectedImageUrl() async {
    try {
      // Get the reference to the selected photo in Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('photos/$selectedFileName');

      // Get the download URL for the image
      selectedImageUrl = await storageReference.getDownloadURL();

      // Force a rebuild to display the selected image
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _logger.e('Error loading selected image: $e');
    }
  }

  Future<void> _deletePhoto(BuildContext context) async {
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
            FirebaseStorage.instance.ref().child('photos/$selectedFileName');

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (photoFileNames.isNotEmpty)
              DropdownButton<String>(
                value: selectedFileName,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFileName = newValue!;
                    loadSelectedImageUrl();
                  });
                },
                items: photoFileNames.map((String fileName) {
                  return DropdownMenuItem<String>(
                    value: fileName,
                    child: Text(fileName),
                  );
                }).toList(),
              ),
            if (selectedImageUrl.isNotEmpty)
              Image.network(
                selectedImageUrl,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _deletePhoto(context),
              child: const Text('Delete Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
