import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register a new user with email and password
  Future<User?> registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
  ) async {
    try {
      // Create user with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user from the credential
      User? user = credential.user;

      // Store user information in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
      });

      return user;
    } catch (e) {
      // Handle registration error
      print("Error occurred in registration: $e");
      return null;
    }
  }

  // Sign in user with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Sign in with email and password
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Return the signed-in user
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Handling invalid email or password
        print('Invalid email or password: ${e.code}');
      } else {
        // Handling other authentication errors
        print('An error occurred: ${e.code}');
      }
    } catch (e) {
      // Handle general error
      print("Error occurred during sign-in: $e");
    }
    return null;
  }
}
