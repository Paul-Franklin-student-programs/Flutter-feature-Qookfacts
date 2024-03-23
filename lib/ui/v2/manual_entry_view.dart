import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/open_ai_service.dart';
import 'package:qookit/ui/v2/recipes_view.dart';

class ManualEntryView extends StatefulWidget {
  @override
  _ManualEntryViewState createState() => _ManualEntryViewState();
}

class _ManualEntryViewState extends State<ManualEntryView> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? 'xyz';

  final TextEditingController _controller = TextEditingController();
  List<String> ingredientsList = []; // List to store dietary restrictions
  bool isLoading = false; // Variable to control the visibility of CircularProgressIndicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Ingredients Manually', style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        iconTheme: IconThemeData(color: Colors.black), // Apply black color to the app bar icons
        actionsIconTheme: IconThemeData(color: Colors.black), // Apply black color to the app bar action icons
      ),
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter an ingredient',
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
                final String ingredient = _controller.text.trim();
                if (ingredient.isNotEmpty) {
                  setState(() {
                    ingredientsList.add(ingredient); // Add restriction to the list
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
            _buildIngredientsList(), // Pass the list directly
            if (isLoading) // Show CircularProgressIndicator if isLoading is true
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 10.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isLoading = true; // Set isLoading to true when FloatingActionButton is pressed
              });
              processData(context);
            },
            child: Icon(Icons.restaurant),
          ),
          Text(
            'Qookit (~15s)',
            style: qookitLight.tabBarTheme.labelStyle,
          ),
        ],
      ),
    );
  }

  void processData(BuildContext context) async {
    try {
      String response = await OpenAiService.fetchRecipes(ingredientsList.toString(), true, false);
      setState(() {
        isLoading = false; // Set isLoading to false when data processing is complete
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return RecipesView(response);
          },
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Set isLoading to false if an error occurs
      });
      // Handle error
      print('Error processing data: $e');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to process data. Please try again later.'),
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

  Widget _buildIngredientsList() {
    return ListView.builder(
      shrinkWrap: true, // Ensure ListView takes only the space it needs
      itemCount: ingredientsList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            ingredientsList[index],
            style: qookitLight.textTheme.bodyText1, // Apply qookit theme to the list item text
          ),
        );
      },
    );
  }
}
