import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras![0], // Use back camera
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {}); // Refresh UI
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF072f5f),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Camera Preview
                _cameraController != null && _cameraController!.value.isInitialized
                    ? CameraPreview(_cameraController!)
                    : Container(color: Colors.black), // Black background until loaded

                // Scanning Box (Centered)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35, // Center dynamically
                  child: Container(
                    width: 250,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xFF072f5f), width: 3), // Match background color
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scan Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                // Implement scan logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(200, 50),
              ),
              icon: Icon(Icons.qr_code_scanner, color: Colors.white),
              label: Text("SCAN NUMBERS", style: TextStyle(color: Colors.white)),
            ),
          ),

          // Bottom Navigation Bar
          BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: ""),
            ],
          ),
        ],
      ),
    );
  }
}
