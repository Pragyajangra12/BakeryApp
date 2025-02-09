import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset('lib/images/logo.png'),
            const SizedBox(height: 20), // Space between logo and buttons

            // Column for vertical buttons with custom height and width
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button 1
                SizedBox(
                  width: 300, // Set the width of Button 1
                  height: 50, // Set the height of Button 1
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for Button 1
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 20), // Space between buttons
                // Button 2
                SizedBox(
                  width: 300, // Set the width of Button 2
                  height: 50, // Set the height of Button 2
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for Button 2
                    },
                    child: const Text('Create New Account'),
                  ),
                ),
                const SizedBox(height: 20), // Space between Button 2 and "Forgot Password"
                // Forgot Password text
                TextButton(
                  onPressed: () {
                    // Action for Forgot Password
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white, // Color of the text
                       // Underline the text
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
