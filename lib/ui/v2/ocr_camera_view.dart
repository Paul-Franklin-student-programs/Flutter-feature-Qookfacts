import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/nutrition_view.dart';
import 'package:qookit/ui/v2/recipes_view.dart';
import 'package:qookit/ui/v2/scanned_ingredients_view.dart';
import 'package:qookit/ui/v2/services/facade_service.dart';
import 'package:qookit/ui/v2/virtual_pantry_scan_view.dart';

import 'services/hive_service.dart';

class OCRCameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final bool isReceiptScanSelected; // Flag for Receipt Scanner
  final bool isIngredientScanSelected;

  const OCRCameraView({
    Key? key,
    required this.cameras,
    required this.isReceiptScanSelected,
    required this.isIngredientScanSelected,
  }) : super(key: key);

  @override
  State<OCRCameraView> createState() => _OCRCameraViewState();
}

class _OCRCameraViewState extends State<OCRCameraView> {
  String userId = FirebaseAuth.instance.currentUser!.uid!;
  late CameraController controller;
  File? photoFile;
  bool processing = false;
  String ocrKey = '';

  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void takePhoto() async {
    try {
      XFile photo = await controller.takePicture();
      setState(() {
        photoFile = File(photo.path);
      });
    } catch (e) {
      print(e);
    }
  }

  void deletePhoto() {
    setState(() {
      photoFile = null;
    });
  }

  void processPhoto(BuildContext context) async {
    setState(() {
      processing = true;
    });

    if (photoFile != null) {
      String ocrResponse = await FacadeService.sendOCRRequest(await photoFile!.path);
      final dietaryRestrictionsBox = await Hive.box<List<String>>(HiveBoxes.dietaryRestrictions);
      List<String> dietaryRestrictions = dietaryRestrictionsBox.get(userId, defaultValue: [])!;
      final culinaryPreferencesBox = await Hive.box<List<String>>(HiveBoxes.culinaryPreferences);
      List<String> culinaryPreferences = culinaryPreferencesBox.get(userId, defaultValue: [])!;

      if (widget.isReceiptScanSelected) {
        ocrResponse = await FacadeService.fetchIngredients(ocrResponse);
      } else if (widget.isIngredientScanSelected) {
        ocrResponse = await FacadeService.fetchRecipes(ocrResponse, dietaryRestrictions.join(','), culinaryPreferences.join(','), widget.isReceiptScanSelected, widget.isIngredientScanSelected);

      }

      setState(() {
        processing = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            if (widget.isReceiptScanSelected) {
              return ScannedIngredientsView(ingredients:ocrResponse.split(','));
            } else if (widget.isIngredientScanSelected) {
              return NutritionView(ocrResponse);
            }
            // Return a default view if neither is selected
            return Container();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Theme(
        data: qookitLight,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              photoFile == null
                  ? Container(
                width: double.infinity,
                height: double.infinity,
                child: CameraPreview(controller),
              )
                  : Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.file(photoFile!, fit: BoxFit.fill),
              ),
              if (processing)
                Center(
                  child: Container(
                    width: 100, // Set the desired width
                    height: 100, // Set the desired height
                    child: CircularProgressIndicator(
                      strokeWidth: 10.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: photoFile == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        Text(
                          'Go Back',
                          style: qookitLight.tabBarTheme.labelStyle,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        FloatingActionButton(
                          onPressed: takePhoto,
                          child: Icon(Icons.camera),
                        ),
                        Text(
                          widget.isReceiptScanSelected ? 'Capture Receipt' : 'Capture Nutrition Label',
                          style: qookitLight.tabBarTheme.labelStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                        onPressed: deletePhoto,
                        child: Icon(Icons.delete),
                      ),
                      Text(
                        'Discard and Retry',
                        style: qookitLight.tabBarTheme.labelStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          processPhoto(context);
                        },
                        child: widget.isReceiptScanSelected ? Icon(Icons.add_shopping_cart) : Icon(Icons.restaurant_menu),
                      ),
                      Text(
                        widget.isReceiptScanSelected ? 'Add to Pantry' : 'Qookit (~15s)',
                        style: qookitLight.tabBarTheme.labelStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
