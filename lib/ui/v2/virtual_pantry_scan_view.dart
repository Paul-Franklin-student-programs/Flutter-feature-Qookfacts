import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/services/facade_service.dart';
import 'package:qookit/ui/v2/recipes_view.dart';
import 'package:hive/hive.dart';
import 'services/hive_service.dart';

class VirtualPantryScanView extends StatefulWidget {
  @override
  _VirtualPantryScanState createState() => _VirtualPantryScanState();
}

class _VirtualPantryScanState extends State<VirtualPantryScanView> {
  String userId = FirebaseAuth.instance.currentUser!.uid!;
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();
  List<String> pantryItems = [];

  @override
  void initState() {
    super.initState();
    _loadPantryItems();
  }

  Future<void> _loadPantryItems() async {
    final pantryBox = await Hive.openBox<List<String>>(HiveBoxes.virtualPantry);
    setState(() {
      pantryItems = pantryBox.get(userId, defaultValue: [])!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Pantry Based Recipes', style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        iconTheme: IconThemeData(color: Colors.black54),
        actionsIconTheme: IconThemeData(color: Colors.black54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'This will suggest recipes based on your user preferences and virtual pantry ingredients below',
              style: qookitLight.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (isLoading)
              CircularProgressIndicator(
                strokeWidth: 4.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            SizedBox(height: 20),
            _buildAddIngredientField(),
            SizedBox(height: 20),
            Expanded(child: _buildPantryItemList()),
          ],
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
                  isLoading = true;
                });
                await processData(context);
                setState(() {
                  isLoading = false;
                });
              },
              child: Icon(Icons.restaurant),
            ),
          ),
          Positioned(
            bottom: 90.0,
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

  Widget _buildAddIngredientField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Add an item',
              labelStyle: qookitLight.textTheme.bodyText1,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            ),
            style: qookitLight.textTheme.bodyText1,
            cursorColor: Colors.black54,
          ),
        ),
        SizedBox(width: 10), // Add some space between the text field and button
        IconButton(
          icon: Icon(Icons.add, color: Colors.amber),
          onPressed: () {
            final String item = _controller.text.trim();
            if (item.isNotEmpty) {
              setState(() {
                pantryItems.add(item);
                _controller.clear();
              });
              _updatePantry();
            }
          },
        ),
      ],
    );
  }

  Widget _buildPantryItemList() {
    return ListView.builder(
      itemCount: pantryItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            pantryItems[index],
            style: qookitLight.textTheme.bodyText1,
          ),
          trailing: IconTheme(
            data: IconThemeData(color: Colors.amber),
            child: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                _removeItem(index);
              },
            ),
          ),
        );
      },
    );
  }

  void _updatePantry() async {
    final pantryBox = await Hive.openBox<List<String>>(HiveBoxes.virtualPantry);
    pantryBox.put(userId, pantryItems);
  }

  void _removeItem(int index) {
    setState(() {
      pantryItems.removeAt(index);
    });
    _updatePantry();
  }

  Future<void> processData(BuildContext context) async {
    try {
      final dietaryRestrictionsBox = await Hive.box<List<String>>(HiveBoxes.dietaryRestrictions);
      List<String> dietaryRestrictions = dietaryRestrictionsBox.get(userId, defaultValue: [])!;
      final culinaryPreferencesBox = await Hive.box<List<String>>(HiveBoxes.culinaryPreferences);
      List<String> culinaryPreferences = culinaryPreferencesBox.get(userId, defaultValue: [])!;

      String response = await FacadeService.fetchRecipes(
        pantryItems.join(','),
        dietaryRestrictions.join(','),
        culinaryPreferences.join(','),
        true,
        false,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return RecipesView(response, pantryItems.join(','), showAddToPantryButton: false);
          },
        ),
      );
    } catch (e) {
      print('Error processing data: $e');
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