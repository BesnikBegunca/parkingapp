import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool isCameraReady = false;
  String? scannedPlate;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras[0],
      ResolutionPreset.high,
    );
    await _cameraController.initialize();

    setState(() {
      isCameraReady = true;
    });
  }

  Future<void> _scanLicensePlate() async {
    if (_cameraController.value.isInitialized) {
      final image = await _cameraController.takePicture();
      final plate = await _extractTextFromImage(image);
      setState(() {
        scannedPlate = plate;
      });
    }
  }

  Future<String> _extractTextFromImage(XFile image) async {
    // Create an instance of the TextRecognizer
    final textRecognizer = TextRecognizer();

    // Convert the image to an InputImage
    final inputImage = InputImage.fromFilePath(image.path);

    // Process the image for text recognition
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String plate = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        plate += line.text + ' ';
      }
    }

    // Close the recognizer after use
    textRecognizer.close();
    return plate.trim();
  }


  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parking App')),
      body: isCameraReady
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            child: CameraPreview(_cameraController),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _scanLicensePlate,
            child: Text('Scan License Plate'),
          ),
          if (scannedPlate != null) Text('Scanned Plate: $scannedPlate'),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
