import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user?.uid; // Return user ID if sign-in successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message if sign-in fails
    } catch (e) {
      return 'An unexpected error occurred'; // Return generic error message
    }
  }

  Future<String?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user?.uid; // Return user ID if registration successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message if registration fails
    } catch (e) {
      return 'An unexpected error occurred'; // Return generic error message
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<String?> getToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  Future<String?> deactivateAccount() async {
    try {
      await _auth.currentUser?.delete();
      return null; // Return null if deletion is successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Please re-authenticate to deactivate your account.';
      }
      return e.message; // Return specific Firebase error message
    } catch (e) {
      return 'An unexpected error occurred'; // Return generic error message
    }
  }
}