import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/services/facade_service.dart';
import 'package:qookit/ui/v2/recipes_view.dart';
import 'package:hive/hive.dart';

import 'services/hive_service.dart';

class VirtualPantryScan extends StatefulWidget {
  @override
  _VirtualPantryScanState createState() => _VirtualPantryScanState();
}

class _VirtualPantryScanState extends State<VirtualPantryScan> {
  String userId = FirebaseAuth.instance.currentUser!.uid!;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Pantry Scan', style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        iconTheme: IconThemeData(color: Colors.black54), // Apply black color to the app bar icons
        actionsIconTheme: IconThemeData(color: Colors.black54), // Apply black color to the app bar action icons
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'This will suggest recipes based on your virtual pantry and dietary restrictions',
                style: qookitLight.textTheme.headline4,
                textAlign: TextAlign.center, // Center-align the text
              ),
              SizedBox(height: 20),
              if (isLoading) // Show CircularProgressIndicator if isLoading is true
                CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () async {
                setState(() {
                  isLoading = true; // Set isLoading to true when button is pressed
                });
                await processData(context);
                setState(() {
                  isLoading = false; // Set isLoading to false when data processing is complete
                });
              },
              child: Icon(Icons.restaurant),
            ),
          ),
          Positioned(
            bottom: 90.0, // Adjust the position as needed
            right: 16.0,
            child: Text(
              'Qookit (~15s)',
              style: qookitLight.tabBarTheme.labelStyle,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> processData(BuildContext context) async {
    try {
      final dietaryRestrictionsBox = await Hive.box<List<String>>(HiveBoxes.dietaryRestrictions);
      List<String> dietaryRestrictions = dietaryRestrictionsBox.get(userId, defaultValue: [])!;
      final virtualPantryBox = await Hive.box<List<String>>(HiveBoxes.virtualPantry);
      List<String> virtualPantryIngredients = virtualPantryBox.get(userId, defaultValue: [])!;

      String response = await FacadeService.fetchRecipes(
        virtualPantryIngredients.join(','),
        dietaryRestrictions.join(','),
        true,
        false,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return RecipesView(response);
          },
        ),
      );
    } catch (e) {
      // Handle error
      print('Error processing data: $e');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to process data. Please try again later. $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
