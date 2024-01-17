import 'package:flutter/material.dart';
import 'photo_upload_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhotoUploadScreen()),
            );
          },
          child: Text('Upload Photo'),
        ),
      ),
    );
  }
}
