import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/ui/v2/manual_entry_view.dart';
import 'package:qookit/ui/v2/ocr_camera_view.dart';
import 'package:qookit/ui/v2/services/auth_service.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/user_preferences_view.dart'; // Import the UserPreferencesView

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserPreferencesView(),
                ),
              );
            },
            icon: Icon(Icons.settings, color: Colors.black), // Add icon for User Preferences
          ),
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            String userEmail = user?.email ?? "Unknown User";

            return Column(
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Hello, $userEmail",
                    style: qookitLight.textTheme.headline6,
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
