import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qookit/ui/v2/services/auth_service.dart';
import 'package:qookit/ui/v2/services/qookit_service.dart';
import 'package:qookit/services/theme/theme_service.dart';


import 'package:qookit/models/location.dart';
import 'package:qookit/models/personal.dart';
import 'package:qookit/models/preference.dart';
import 'package:qookit/models/user.dart';


class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController(); // New controller
  String? message; // Variable to store message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up", style: qookitLight.textTheme.headline4),
        backgroundColor: qookitLight.primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black54),
        actionsIconTheme: IconThemeData(color: Colors.black54),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
              ),
              style: qookitLight.textTheme.headline6,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: qookitLight.textTheme.headline6,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            TextField(
              controller: confirmPasswordController, // New field
              obscureText: true,
              style: qookitLight.textTheme.headline6,
              decoration: InputDecoration(
                labelText: "Confirm Password",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final password = passwordController.text.trim();
                final confirmPassword = confirmPasswordController.text.trim();

                if (password != confirmPassword) {
                  setState(() {
                    message = "Passwords do not match."; // Update message
                  });
                  return;
                }

                final authService = Provider.of<AuthService>(context, listen: false);
                final result = await authService.registerWithEmailAndPassword(
                  emailController.text.trim(),
                  password,
                );

                if (result != null && result.length == 28) { // Check if result is a user ID
                  // Assuming `result` contains user ID
                  final userId = result;
                  final userName = generateRandomUsername();
                  final displayName = userName;

                  final userRoot = UserRoot(
                    userName: userName,
                    displayName: displayName,
                    preferences: Preference(
                      units: 'Imperial',
                      diet: ['temp'],
                      recipe: ['temp'],
                    ),
                    personal: Personal(
                      firstName: 'qookittempfirstname',
                      lastName: 'qookittemplastname',
                      fullName: 'qookittempfullname',
                      email: emailController.text.trim(),
                      aboutMe: 'temp',
                      homeUrl: 'temp',
                      location: Location(
                        city: 'San Diego',
                        state: 'CA',
                        country: 'USA',
                        zip: '92126',
                        gps: '37.4217197,-122.0841305',
                        ipAddr: '192.168.1.1',
                      ),
                    ),
                    backgroundUrl: 'temp',
                    photoUrl: 'temp',
                    id: userId,
                    recipes: [],
                    pantryItems: [],
                  );

                  try {
                    await QookitService().addUserToBackend(addUser: userRoot);
                    setState(() {
                      message = "Registration successful!";
                    });

                    // Navigate back after a short delay
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.pop(context); // Navigate back to previous screen
                    });
                  } catch (e) {
                    setState(() {
                      message = "Failed to create user profile: $e";
                    });
                  }
                } else {
                  setState(() {
                    message = result; // Error message
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
              ),
              child: Text('Register', style: qookitLight.textTheme.headline6),
            ),
            if (message != null) // Show message if not null
              Text(
                message!,
                style: TextStyle(
                  color: message == "Registration successful!" ? Colors.green : Colors.red, // Conditional color
                ),
              ),
          ],
        ),
      ),
    );
  }


  String generateRandomUsername() {
    final random = Random();
    final randomNumber = random.nextInt(900) + 100; // Generates a random number between 100 and 999
    return 'qookituser$randomNumber';
  }

}