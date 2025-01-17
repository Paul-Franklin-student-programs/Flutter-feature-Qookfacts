import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/ui/v2/instant_recipe_finder_view.dart';
import 'package:qookit/ui/v2/ocr_camera_view.dart';
import 'package:qookit/ui/v2/services/auth_service.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/user_preferences_view.dart';
import 'package:qookit/ui/v2/virtual_pantry_scan_view.dart';
import 'package:qookit/ui/v2/qookit_tips_utility.dart';
import 'package:qookit/ui/v2/deactivate_account_view.dart'; // Import the deactivation view

class HomeView extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomeView({required this.cameras});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String qookitTip;

  //fetches and displays Tip when HomeView is first loaded
  @override
  void initState() {
    super.initState();
    qookitTip = QookitTips().loadNewTip();
  }

  // refreshes Qookit Tip to display a new Tip
  void refreshQookitTip() {
    setState(() {
      qookitTip = QookitTips().loadNewTip();
    });
  }

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
                          // Virtual Pantry Button
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VirtualPantryScanView(),
                                ),
                              ).then((_) {
                                refreshQookitTip();
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
                                  "Virtual Pantry",
                                  style: qookitLight.textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                          // Scan To Update Virtual Pantry Button
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
                              ).then((_) {
                                refreshQookitTip();
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
                                  "Scan To Update Virtual Pantry",
                                  style: qookitLight.textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                          // Scan Label Ingredients Button
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
                              ).then((_) {
                                refreshQookitTip();
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
                                  "Scan Label Ingredients For Nutrition Info",
                                  style: qookitLight.textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                          // Search Recipes By Ingredients Button
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InstantRecipeFinderView(),
                                ),
                              ).then((_) {
                                refreshQookitTip();
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
                                  "Search Recipes By Ingredients",
                                  style: qookitLight.textTheme.headline5,
                                ),
                              ),
                            ),
                          ),
                          /* Qooking Tips Button
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QookitTipsView(),
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
                                  "Qooking Tips",
                                  style: qookitLight.textTheme.headline5,
                                ),
                              ),
                            ),
                          ),*/
                          // Deactivate Account Button
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeactivateAccountView(),
                                ),
                              ).then((_) {
                                refreshQookitTip();
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
                                  "Delete Account",
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
                /*Positioned(
                  bottom: 175,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      qookitTip,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Comfortaa', fontStyle: FontStyle.italic, fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),*/


                Positioned(
                  bottom: 175,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      color: Colors.transparent, // Make the Material background transparent
                      //user refreshes tip by tapping the text
                      child: InkWell(
                        onTap: refreshQookitTip,
                        child: Text(
                          qookitTip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Comfortaa',
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),



                Positioned(
                  bottom: 20 + paddingBottom,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Beta version: You may encounter occasional bugs or availability issues. Feedback? Email help@qookit.ai.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'opensans', fontSize: 10, color: Colors.black54),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}