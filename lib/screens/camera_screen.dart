import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
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
              fit: BoxFit.cover,
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
                        await _toggleFlash();

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
                    icon: Icon(
                      isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      _toggleFlash();
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

  Future<void> _toggleCamera(BuildContext context) async {
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

    updateCameraController(newController);
  }

  Future<void> updateCameraController(CameraController newController) async {
    if (widget.cameraController.value.isInitialized) {
      await widget.cameraController.dispose();
    }

    await newController.initialize();

    setState(() {
      widget.cameraController = newController;
      isFrontCamera = !isFrontCamera;
    });
  }

  Future<void> _toggleFlash() async {
    if (widget.cameraController.value.isInitialized) {
      final bool currentFlash =
          widget.cameraController.value.flashMode == FlashMode.torch;
      final FlashMode newFlashMode =
          currentFlash ? FlashMode.off : FlashMode.torch;

      await widget.cameraController.setFlashMode(newFlashMode);

      setState(() {
        isFlashOn = !currentFlash;
      });
    }
  }
}
