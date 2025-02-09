import 'package:bakery_app/files/front.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listenToAuthChanges();
  }

  // ✅ Listen for Auth Changes and Redirect if Logged In
  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/profile");
      }
    });
  }

  Future<void> _signUp() async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || name.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match.");
      return;
    }

    try {
      // 🔹 Create User in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 🔹 Store User Data in Firestore (Without UID & CreatedAt)
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "email": email,
        "name": name,
        "password": password,  // 🔥 Storing password (NOT recommended)
        "confirmPassword": confirmPassword,  // 🔥 Storing confirm password
      });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FrontPage()),);
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "An error occurred. Please try again.");
    } catch (e) {
      _showError("Failed to save data. Please try again.");
    }
  }


  // ✅ Display Error Messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  'lib/images/logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ),

            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField("Email", emailController, false),
                  const SizedBox(height: 20),
                  _buildInputField("Name", nameController, false),
                  const SizedBox(height: 20),
                  _buildInputField("Password", passwordController, true),
                  const SizedBox(height: 20),
                  _buildInputField("Confirm Password", confirmPasswordController, true),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Reusable Input Field Widget
  Widget _buildInputField(String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            hintStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
