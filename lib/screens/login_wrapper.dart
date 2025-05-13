import 'package:flutter/material.dart';
import 'package:fluttertest/screens/home_screen.dart';
import 'package:fluttertest/screens/login_screen.dart';

class LoginWrapper extends StatelessWidget {
  // Check if user is already logged in
  bool _isLoggedIn() {
    return false; // Simplified for demo
  }

  // Mock authentication function
  Future<bool> _handleLogin(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network request

    // Simple dummy authentication
    if (email == 'user@example.com' && password == 'password123') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // If already logged in, go to home screen
    if (_isLoggedIn()) {
      return HomeScreen();
    }

    // Otherwise show login screen
    return LoginScreen(
      onLogin: (email, password) async {
        bool success = await _handleLogin(email, password);

        if (success) {
          // Navigate to home screen
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid credentials. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }
}