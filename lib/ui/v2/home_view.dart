import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qookit/ui/v2/ocr_camera_view.dart';
import 'package:qookit/services/theme/theme_service.dart';


class HomeView extends StatelessWidget {
  final List<CameraDescription> cameras;
  final bool isReceiptScanSelected; // Flag for Receipt Scanner
  final bool isIngredientScanSelected; // Flag for Ingredient Scanner

  HomeView({
    required this.cameras,
    this.isReceiptScanSelected = false,
    this.isIngredientScanSelected = false,
  });

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
              shrinkWrap: true,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OCRCameraView(
                          cameras: cameras,
                          isReceiptScanSelected: true,
                            isIngredientScanSelected:false
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(
                        "Scan a receipt",
                        style: qookitLight.textTheme.headline5,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OCRCameraView(
                          cameras: cameras,
                          isReceiptScanSelected: false,
                          isIngredientScanSelected: true
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(
                        "Scan a nutrition label",
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
