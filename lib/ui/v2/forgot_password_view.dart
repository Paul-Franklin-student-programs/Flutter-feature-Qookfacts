import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qookit/services/theme/theme_service.dart';

import 'services/auth_service.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password", style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        iconTheme: IconThemeData(color: Colors.black54),
        actionsIconTheme: IconThemeData(color: Colors.black54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              style: qookitLight.textTheme.headline6,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final authService = Provider.of<AuthService>(context, listen: false);
                await authService.sendPasswordResetEmail(emailController.text);
                // Show success message or navigate to a different screen
                // For simplicity, let's just show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Password reset email sent to ${emailController.text}'),
                ));
              },
              style: ElevatedButton.styleFrom(primary: Colors.amber),
              child: Text('Reset Password', style: qookitLight.textTheme.headline6,),
            ),
          ],
        ),
      ),
    );
  }
}
