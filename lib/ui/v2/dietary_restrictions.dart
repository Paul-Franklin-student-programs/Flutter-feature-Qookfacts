import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/services/theme/theme_service.dart';

class DietaryRestrictionsView extends StatefulWidget {
  @override
  _DietaryRestrictionsViewState createState() => _DietaryRestrictionsViewState();
}

class _DietaryRestrictionsViewState extends State<DietaryRestrictionsView> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? 'xyz';

  final TextEditingController _controller = TextEditingController();
  List<String> dietaryRestrictions = []; // List to store dietary restrictions

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
        );
      },
    );
  }
}
