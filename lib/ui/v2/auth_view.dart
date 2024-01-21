import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'package:qookit/services/theme/theme_service.dart';

class AuthView extends StatefulWidget {
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Qookit", style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final authService =
                Provider.of<AuthService>(context, listen: false);
                final user = await authService.signInWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                );

                if (user != null) {
                  // User is signed in, you can navigate to the HomeView
                } else {
                  // Show error message
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.amber),
              child: Text('Sign In',style: qookitLight.textTheme.headline6),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final authService =
                Provider.of<AuthService>(context, listen: false);
                final user = await authService.registerWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                );

                if (user != null) {
                  // User is registered and signed in, you can navigate to the HomeView
                } else {
                  // Show error message
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.amber),
              child: Text('Sign Up', style: qookitLight.textTheme.headline6,),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                final authService =
                Provider.of<AuthService>(context, listen: false);
                await authService.sendPasswordResetEmail(emailController.text);
                // Show success message or navigate to a different screen
              },
              child: Text('Forgot Password?', style: qookitLight.textTheme.headline6,),
            ),
          ],
        ),
      ),
    );
  }
}
