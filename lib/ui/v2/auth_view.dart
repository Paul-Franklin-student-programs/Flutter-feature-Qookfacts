import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'sign_up_view.dart'; // Make sure to import your SignUpView here
import 'forgot_password_view.dart'; // Import the ForgotPasswordView
import 'package:qookit/services/theme/theme_service.dart';

class AuthView extends StatefulWidget {
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage; // Variable to store error message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Qookit", style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black), // Set label text color to black
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)), // Set focused border color to black
              ),
              style: TextStyle(color: Colors.black), // Set input text color to black
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black), // Set label text color to black
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)), // Set focused border color to black
              ),
              style: TextStyle(color: Colors.black), // Set input text color to black
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final authService =
                Provider.of<AuthService>(context, listen: false);
                final errorMessage = await authService.signInWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                );

                setState(() {
                  this.errorMessage = errorMessage; // Update error message
                });

                // If user is signed in, you can navigate to the HomeView
              },
              style: ElevatedButton.styleFrom(primary: Colors.amber),
              child: Text('Sign In', style: qookitLight.textTheme.headline6),
            ),
            if (errorMessage != null) // Show error message if not null
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red), // Error message style
              ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Navigate to SignUpView when Sign Up button is clicked
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SignUpView()));
              },
              style: ElevatedButton.styleFrom(primary: Colors.amber),
              child: Text(
                'Sign Up',
                style: qookitLight.textTheme.headline6,
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Navigate to ForgotPasswordView when Forgot Password text is clicked
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ForgotPasswordView()));
              },
              child: Text(
                'Forgot Password?',
                style: qookitLight.textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
