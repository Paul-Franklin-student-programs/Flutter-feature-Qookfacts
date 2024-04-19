import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart'; // Ensure this import points to your AuthService location
import 'package:qookit/services/theme/theme_service.dart'; // Adjust this import based on your project structure

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage; // Variable to store error message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up", style: qookitLight.textTheme.headline4),
        backgroundColor: qookitLight.primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
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
              style: qookitLight.textTheme.headline6
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: qookitLight.textTheme.headline6,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService = Provider.of<AuthService>(context, listen: false);
                final errorMessage = await authService.registerWithEmailAndPassword(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

                setState(() {
                  this.errorMessage = errorMessage; // Update error message
                });

                // If user is registered successfully, you can navigate back to login or another screen
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
              ),
              child: Text('Register', style: qookitLight.textTheme.headline6),
            ),
            if (errorMessage != null) // Show error message if not null
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red), // Error message style
              ),
          ],
        ),
      ),
    );
  }
}
