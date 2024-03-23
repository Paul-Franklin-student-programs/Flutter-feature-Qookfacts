import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/services/theme/theme_service.dart';

class DietaryRestrictionsView extends StatefulWidget {
  @override
  _DietaryRestrictionsViewState createState() => _DietaryRestrictionsViewState();
}

class _DietaryRestrictionsViewState extends State<DietaryRestrictionsView> {
  String userId = FirebaseAuth.instance.currentUser!.uid!;

  final TextEditingController _controller = TextEditingController();
  List<String> dietaryRestrictions = []; // List to store dietary restrictions

  // Define a reference to the Hive box
  late Box<List<String>> _dietaryRestrictionsBox;

  @override
  void initState() {
    super.initState();
    // Open the Hive box for dietary restrictions
    _openDietaryRestrictionsBox();
  }

  // Open the Hive box for dietary restrictions
  // Open the Hive box for dietary restrictions
  Future<void> _openDietaryRestrictionsBox() async {
    try {
      _dietaryRestrictionsBox = await Hive.openBox<List<String>>('dietary_restrictions');
      // Retrieve dietary restrictions from the box when the view is initialized
      setState(() {
        dietaryRestrictions = _dietaryRestrictionsBox.get(userId, defaultValue: [])!;
      });
      print('Dietary restrictions loaded: $dietaryRestrictions');
    } catch (error) {
      print('Error opening Hive box: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dietary Restrictions', style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        iconTheme: IconThemeData(color: Colors.black), // Apply black color to the app bar icons
        actionsIconTheme: IconThemeData(color: Colors.black), // Apply black color to the app bar action icons
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter a dietary restriction',
                labelStyle: TextStyle(color: Colors.black), // Set label text color to black
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)), // Set border color to black
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)), // Set focused border color to black
              ),
              style: TextStyle(color: Colors.black), // Set input text color to black
              cursorColor: Colors.black, // Set cursor color to black
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final String restriction = _controller.text.trim();
              if (restriction.isNotEmpty) {
                setState(() {
                  dietaryRestrictions.add(restriction); // Add restriction to the list
                });
                _controller.clear();
                // Save the updated dietary restrictions list to the Hive box
                _updateDietaryRestrictions();
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.amber), // Apply amber color to the button
            child: Text(
              'Add',
              style: qookitLight.textTheme.headline6, // Apply qookit theme to the button text
            ),
          ),
          Expanded(
            child: _buildDietaryRestrictionsList(), // Pass the list directly
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryRestrictionsList() {
    return ListView.builder(
      itemCount: dietaryRestrictions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            dietaryRestrictions[index],
            style: qookitLight.textTheme.bodyText1, // Apply qookit theme to the list item text
          ),
          trailing: IconButton(
            icon: Icon(Icons.remove_circle),
            onPressed: () {
              _removeDietaryRestriction(index);
            },
          ),
        );
      },
    );
  }

  void _updateDietaryRestrictions() {
    _dietaryRestrictionsBox.put(userId, dietaryRestrictions); // Update data in Hive box
  }

  void _removeDietaryRestriction(int index) {
    setState(() {
      dietaryRestrictions.removeAt(index); // Remove item from the list
    });
    // Update the Hive box to reflect the changes
    _updateDietaryRestrictions();
  }
}
