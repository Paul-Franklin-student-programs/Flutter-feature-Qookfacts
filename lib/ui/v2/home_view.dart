import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/ui/v2/instant_recipe_finder_view.dart';
import 'package:qookit/ui/v2/ocr_camera_view.dart';
import 'package:qookit/ui/v2/services/auth_service.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/user_preferences_view.dart';
import 'package:qookit/ui/v2/virtual_pantry_scan_view.dart';
import 'package:qookit/ui/v2/virtual_pantry_view.dart';

class HomeView extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomeView({required this.cameras});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool showRecipeButtons = false;

  @override
  Widget build(BuildContext context) {
    var paddingBottom = MediaQuery.of(context).padding.bottom;

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
            icon: Icon(Icons.person, color: Colors.black54),
          ),
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
                                    cameras: widget.cameras,
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
                                  "Scan Receipt",
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
                                    cameras: widget.cameras,
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
                                  "Scan Label Ingredients For Nutrition Info",
                                  style: qookitLight.textTheme.headline5,
                                ),
                              ),
                            ),
                          ),

                          // Find Recipes Button
                          InkWell(
                            onTap: () {
                              setState(() {
                                showRecipeButtons = !showRecipeButtons;
                              });
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
                                  "Find Recipes",
                                  style: qookitLight.textTheme.headline5,
                                ),
                                trailing: Icon(
                                  showRecipeButtons
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                              ),
                            ),
                          ),

                          // Show the expanded buttons if Find Recipes is clicked
                          if (showRecipeButtons) ...[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VirtualPantryView(),
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
                                    "Pantry Based Recipes",
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
                                    builder: (context) => InstantRecipeFinderView(),
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
                                    "Text Based Recipes",
                                    style: qookitLight.textTheme.headline5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10 + paddingBottom,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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