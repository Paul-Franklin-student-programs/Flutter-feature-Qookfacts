import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/services/hive_service.dart';

class VirtualPantryView extends StatefulWidget {
  @override
  _VirtualPantryViewState createState() => _VirtualPantryViewState();
}

class _VirtualPantryViewState extends State<VirtualPantryView> {
  String userId = FirebaseAuth.instance.currentUser!.uid!;

  final TextEditingController _controller = TextEditingController();
  List<String> pantryItems = []; // List to store pantry items

  // Define a reference to the Hive box
  late Box<List<String>> _pantryBox;

  @override
  void initState() {
    super.initState();
    // Open the Hive box for the virtual pantry
    _openPantryBox();
  }

  // Open the Hive box for the virtual pantry
  Future<void> _openPantryBox() async {
    try {
      _pantryBox = await Hive.openBox<List<String>>(HiveBoxes.virtualPantry);
      // Retrieve pantry items from the box when the view is initialized
      setState(() {
        pantryItems = _pantryBox.get(userId, defaultValue: [])!;
      });
      // print('Pantry items loaded: $pantryItems');
    } catch (error) {
      print('Error opening Hive box: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Pantry', style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        iconTheme: IconThemeData(color: Colors.black54), // Apply black color to the app bar icons
        actionsIconTheme: IconThemeData(color: Colors.black54), // Apply black color to the app bar action icons
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Add an item',
                labelStyle: qookitLight.textTheme.bodyText1, // Set label text color to black
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)), // Set border color to black
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)), // Set focused border color to black
              ),
              style: qookitLight.textTheme.bodyText1, // Set input text color to black
              cursorColor: Colors.black54, // Set cursor color to black
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final String item = _controller.text.trim();
              if (item.isNotEmpty) {
                setState(() {
                  pantryItems.add(item); // Add item to the pantry list
                });
                _controller.clear();
                // Save the updated pantry list to the Hive box
                _updatePantry();
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.amber), // Apply amber color to the button
            child: Text(
              'Add',
              style: qookitLight.textTheme.headline6, // Apply qookit theme to the button text
            ),
          ),
          Expanded(
            child: _buildPantryItemList(), // Pass the list directly
          ),
        ],
      ),
    );
  }

  Widget _buildPantryItemList() {
    return ListView.builder(
      itemCount: pantryItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            pantryItems[index],
            style: qookitLight.textTheme.bodyText1, // Apply qookit theme to the list item text
          ),
          trailing: IconTheme(
            data: IconThemeData(color: Colors.amber), // Set the color of the icon
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

  void _updatePantry() {
    _pantryBox.put(userId, pantryItems); // Update data in Hive box
  }

  void _removeItem(int index) {
    setState(() {
      pantryItems.removeAt(index); // Remove item from the list
    });
    // Update the Hive box to reflect the changes
    _updatePantry();
  }
}
