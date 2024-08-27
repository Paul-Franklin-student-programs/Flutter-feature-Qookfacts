import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart'; // Ensure this import points to your AuthService location
import 'package:qookit/services/theme/theme_service.dart'; // Adjust this import based on your project structure
import 'sign_in_view.dart'; // Import your sign-in page

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

                setState(() {
                  if (result != null && result.length == 28) { // Check if result is a user ID
                    message = "Registration successful!"; // Update message

                    // Navigate back after a short delay
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.pop(context); // Navigate back to previous screen
                    });
                  } else {
                    message = result; // Error message
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
              ),
              child: Text('Register', style: qookitLight.textTheme.headline6),
            ),
            if (message != null) // Show message if not null
              Text(
                message!,
                style: TextStyle(color: message == "Registration successful!" ? Colors.green : Colors.red), // Conditional color
              ),
          ],
        ),
      ),
    );
  }
}