import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qookit/ui/v2/ocr_camera_view.dart';
import 'package:qookit/services/theme/theme_service.dart';

class HomeView extends StatelessWidget {
  final List<CameraDescription> cameras; // Add this line

  HomeView({required this.cameras}); // Constructor to receive the cameras list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Qookit", style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true, // This allows the ListView to wrap its content
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OCRCameraView(cameras: cameras), // Pass cameras to OCRCameraView
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    ),
                    padding: EdgeInsets.all(16.0), // Padding for content
                    child: ListTile(
                      title: Text(
                        "Receipt Scanner",
                        style: qookitLight.textTheme.headline5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
