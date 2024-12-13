import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'package:qookit/services/theme/theme_service.dart';

class DeactivateAccountView extends StatelessWidget {
  Future<void> _deactivateAccount(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    String? result = await authService.deactivateAccount();

    if (result == null) {
      // Successfully deactivated account, navigate to initial screen
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == 'Please re-authenticate to delete your account.'
                ? result
                : 'Error: Unable to delete account. Try again later or contact support.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account", style: qookitLight.textTheme.headline4),
        backgroundColor: qookitLight.primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black54), // Apply black color to the app bar icons
        actionsIconTheme: IconThemeData(color: Colors.black54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Are you sure you want to delete your account? This action cannot be undone.",
              textAlign: TextAlign.center,
              style: qookitLight.textTheme.bodyText1,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _deactivateAccount(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Confirm Deletion",
                style: qookitLight.textTheme.headline6?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}