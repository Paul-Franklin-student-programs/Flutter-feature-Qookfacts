import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/ui/v2/manual_entry_view.dart';
import 'package:qookit/ui/v2/ocr_camera_view.dart';
import 'package:qookit/ui/v2/services/auth_service.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/virtual_pantry_scan_view.dart';
import 'package:qookit/ui/v2/virtual_pantry_view.dart';

import 'dietary_restrictions_view.dart';

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
    // Ensuring that we consider the safe area for devices with a notch or home indicator
    var paddingBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Qookit", style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
            },
            icon: Icon(Icons.logout, color: Colors.black54),
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            String userId = user?.uid ?? "Unknown User";

            return Stack(
              children: [
                Column(
                  children: [
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
                                    isIngredientScanSelected: false,
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
                                    isIngredientScanSelected: true,
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
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VirtualPantryScan(),
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
                                  "Virtual Pantry Based Recipes",
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
                                  builder: (context) => ManualEntryView(),
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
                                  "Enter ingredients manually",
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
                Positioned(
                  bottom: 10 + paddingBottom, // Adjusted to include paddingBottom
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DietaryRestrictionsView(),
                                  ),
                                );
                              },
                              child: Icon(Icons.list, color: Colors.white),
                              backgroundColor: qookitLight.primaryColor,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Diet Restrictions',
                              style: qookitLight.tabBarTheme.labelStyle,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VirtualPantryView(),
                                  ),
                                );
                              },
                              child: Icon(Icons.kitchen, color: Colors.white),
                              backgroundColor: qookitLight.primaryColor,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Virtual Pantry',
                              style: qookitLight.tabBarTheme.labelStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}