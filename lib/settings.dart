import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/internetChecker.dart';
import 'login.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isObscure = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return InternetChecker(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 50,),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Settings',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  _buildTextField(_firstNameController, 'First Name'),
                  _buildTextField(_lastNameController, 'Last Name'),
                  _buildTextField(_usernameController, 'Username'),
                  _buildPasswordField(_passwordController, 'Password'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Update Profile'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5), // Adjust the radius as needed
                  ),
                ),
                child: const Text('Sign Out'),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey), // Border color when not focused
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white), // Border color when focused
          ),
        ),
        // cursorColor: Colors.red,
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: _isObscure, // Use _isObscure here
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey), // Border color when not focused
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white), // Border color when focused
          ),
          // border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure; // Toggle _isObscure value
              });
            },
          ),
        ),
      ),
    );
  }

  void _fetchUserData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        _firstNameController.text = userData['firstName'] ?? '';
        _lastNameController.text = userData['lastName'] ?? '';
        _usernameController.text = userData['username'] ?? '';
        _emailController.text = currentUser.email ?? '';
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void _updateProfile() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Update display name if first name is not empty
        if (_firstNameController.text.isNotEmpty) {
          await currentUser.updateDisplayName(_firstNameController.text);
        }

        // Update password if not empty
        if (_passwordController.text.isNotEmpty) {
          await currentUser.updatePassword(_passwordController.text);
        }

        // Update Firestore data
        DocumentReference userDoc =
            _firestore.collection('users').doc(currentUser.uid);
        Map<String, dynamic> userData = {};

        // Update first name if not empty
        if (_firstNameController.text.isNotEmpty) {
          userData['firstName'] = _firstNameController.text;
        }

        // Update last name if not empty
        if (_lastNameController.text.isNotEmpty) {
          userData['lastName'] = _lastNameController.text;
        }

        // Update username if not empty
        if (_usernameController.text.isNotEmpty) {
          userData['username'] = _usernameController.text;
        }

        await userDoc.update(userData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Error updating profile: $e");
      String errorMessage = "Error updating profile";
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? "Unknown error occurred";
      } else if (e is FirebaseException) {
        errorMessage = e.message ?? "Firestore error occurred";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } catch (e) {
      print("Error signing out: $e");
      // Handle sign-out error
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
