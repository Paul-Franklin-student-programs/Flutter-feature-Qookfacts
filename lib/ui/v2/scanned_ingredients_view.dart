import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/services/hive_service.dart';
import 'package:qookit/ui/v2/virtual_pantry_scan_view.dart'; // Ensure you have the correct path for your theme

class ScannedIngredientsView extends StatefulWidget {
  final List<String> ingredients;

  ScannedIngredientsView({required this.ingredients});

  @override
  _ScannedIngredientsViewState createState() => _ScannedIngredientsViewState();
}

class _ScannedIngredientsViewState extends State<ScannedIngredientsView> {
  String userId = FirebaseAuth.instance.currentUser!.uid!;
  List<String> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _ingredients = widget.ingredients;
  }

  Future<void> saveToVirtualPantry(BuildContext context) async {
    var pantryBox = Hive.box<List<String>>(HiveBoxes.virtualPantry);
    List<String> currentIngredients = pantryBox.get(userId, defaultValue: [])!;
    // Convert the list to a set to remove duplicates
    Set<String> uniqueIngredients = Set.from(currentIngredients);
    uniqueIngredients.addAll(_ingredients); // Add the new ingredients

    // Convert the set back to a list
    currentIngredients = uniqueIngredients.toList();

    // Save the updated list back to the box
    await pantryBox.put(userId, currentIngredients);

    // Showing a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Ingredients saved to virtual pantry"),
    ));

    // Navigate to VirtualPantryScanView
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => VirtualPantryScanView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scanned Ingredients',
          style: qookitLight.textTheme.headline4,
        ),
        backgroundColor: qookitLight.primaryColor,
        iconTheme: IconThemeData(color: Colors.black54),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ingredients identified',
              style: qookitLight.textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _ingredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _ingredients[index],
                    style: qookitLight.textTheme.bodyText1,
                  ),
                  trailing: IconTheme(
                    data: IconThemeData(color: Colors.amber), // Set the color of the icon
                    child: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          _ingredients.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              saveToVirtualPantry(context);
            },
            child: Icon(Icons.add_shopping_cart),
            backgroundColor: qookitLight.primaryColor,
          ),
          SizedBox(height: 8), // Spacing between button and text
          Text(
            'Save to Pantry',
            style: qookitLight.tabBarTheme.labelStyle,
          ),
        ],
      ),
    );
  }
}
