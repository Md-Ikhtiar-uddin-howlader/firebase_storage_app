import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';

class CameraScreen extends StatefulWidget {
  CameraController cameraController;

  CameraScreen(this.cameraController);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isFrontCamera = false;
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CameraPreview(widget.cameraController),
                Positioned(
                  bottom: 16,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final XFile photo =
                            await widget.cameraController.takePicture();
                        _logger.d('Photo taken successfully: ${photo.path}');
                        Navigator.pop(context, photo);
                      } catch (e) {
                        _logger.e('Error taking photo: $e');
                        Navigator.pop(context, null); // Return null on error
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Icon(
                      Icons.camera,
                      size: 36,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isFrontCamera = !isFrontCamera;
                    _toggleCamera();
                  });
                },
                child: const Text('Toggle Camera'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleCamera() async {
    final cameras = await availableCameras();
    final newCameraDescription = isFrontCamera
        ? cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front)
        : cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back);

    if (widget.cameraController.value.isInitialized) {
      await widget.cameraController.dispose();
    }

    widget.cameraController = CameraController(
      newCameraDescription,
      ResolutionPreset.medium,
    );

    await widget.cameraController.initialize();

    setState(() {});
  }
}
