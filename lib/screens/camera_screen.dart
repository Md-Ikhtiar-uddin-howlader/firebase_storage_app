import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';

class CameraScreen extends StatefulWidget {
  CameraController cameraController;
  CameraScreen(this.cameraController, {super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController cameraController;
  bool isFrontCamera = false;
  bool isFlashOn = false;
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(
            widget.cameraController,
            child: FittedBox(
              fit: BoxFit
                  .cover, // Ensures full screen coverage without stretching
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      isFrontCamera ? Icons.camera_rear : Icons.camera_front,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: () {
                      _toggleCamera(context);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final XFile photo =
                            await widget.cameraController.takePicture();
                        _logger.d('Photo taken successfully: ${photo.path}');
                        if (!context.mounted) return;
                        Navigator.pop(context, photo);
                      } catch (e) {
                        _logger.e('Error taking photo: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Error taking photo. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
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
                  IconButton(
                    icon: const Icon(
                      Icons.flash_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // Handle flash toggle
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCamera(BuildContext context) async {
    final cameras = await availableCameras();
    final newCameraDescription = isFrontCamera
        ? cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front)
        : cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back);

    final newController = CameraController(
      newCameraDescription,
      ResolutionPreset.medium,
    );

    updateCameraController(newController); // No need for await here

    // If you need to perform other operations after updating the controller, you can do them here.
  }

  void updateCameraController(CameraController newController) async {
    if (widget.cameraController.value.isInitialized) {
      await widget.cameraController.dispose();
    }

    await newController.initialize();

    setState(() {
      widget.cameraController = newController;
      isFrontCamera = !isFrontCamera;
    });
  }

  @override
  void dispose() {
    widget.cameraController.dispose();
    super.dispose();
  }
}
