import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Import SignUpScreen
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import dart:convert for jsonEncode
import 'chat_screen.dart'; // Import ChatScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String loginUrl =
      "https://api.maizbaan.ai/api/v1/users/login"; // Replace with your actual API

  void _login() async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // If login is successful, navigate to ChatScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } else {
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Please check your credentials.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 7, 255, 222),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextField(
              controller: _emailController,
              labelText: "Email",
              icon: Icons.email,
            ),
            SizedBox(height: 12),
            _buildTextField(
              controller: _passwordController,
              labelText: "Password",
              icon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 10, 223, 205), // Black button
                foregroundColor: Colors.white, // White text
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _login,
              child: Text("Login", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.black), // Black text
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black), // Black input text
      cursorColor: Colors.black, // Black cursor
      decoration: InputDecoration(
        labelText: labelText, // Floating label text
        labelStyle: TextStyle(
            color:
                const Color.fromARGB(221, 3, 2, 1)), // Slightly lighter black
        prefixIcon: Icon(icon,
            color: const Color.fromARGB(255, 9, 231, 201)), // Black icon
        filled: true,
        fillColor: Colors.grey[100], // Light background
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: const Color.fromARGB(255, 9, 231, 201), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
