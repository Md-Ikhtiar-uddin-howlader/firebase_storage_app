import 'package:flutter/material.dart';
import 'photo_upload_screen.dart';
import 'photo_delete_screen.dart';
import 'photo_view_screen.dart'; // Import the new screen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotoUploadScreen()),
                );
              },
              child: Text('Upload Photo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotoDeleteScreen()),
                );
              },
              child: Text('Delete Photos'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to PhotoViewScreen without specifying a particular image path
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotoViewScreen()),
                );
              },
              child: Text('View All Photos'),
            ),
          ],
        ),
      ),
    );
  }
}
