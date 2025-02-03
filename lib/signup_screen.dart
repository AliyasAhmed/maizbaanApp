import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart'; // Import HomeScreen to navigate after signup

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _agentNameController = TextEditingController();
  final String signUpUrl =
      "https://maizbaan.ai/api/v1/users/signup"; // Replace with your API

  bool loading = false;
  String error = '';
  String success = '';
  List<dynamic> agencies = [];
  String selectedAgency = '';

  // Fetch agencies from the API
  void fetchAgencies() async {
    setState(() => loading = true);
    final response =
        await http.get(Uri.parse("https://maizbaan.ai/api/v1/users/agencies"));

    if (response.statusCode == 200) {
      setState(() {
        agencies = jsonDecode(response.body);
      });
    } else {
      setState(() => error = "Error fetching agencies.");
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchAgencies();
  }

  void _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => error = "Passwords do not match!");
      return;
    }
    if (selectedAgency.isEmpty) {
      setState(() => error = "Please select a travel agency.");
      return;
    }

    setState(() {
      loading = true;
      error = '';
      success = '';
    });

    final response = await http.post(
      Uri.parse(signUpUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
        "phonenumber": _phonenumberController.text,
        "agency_id": selectedAgency,
        "agentName": _agentNameController.text,
      }),
    );

    if (response.statusCode == 201) {
      setState(() => success = "Signup successful! Welcome to the platform.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() => error = "Something went wrong. Try again!");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Sign Up", style: TextStyle(color: Colors.black))),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40), // Added space at the top

                if (error.isNotEmpty)
                  Text(error,
                      style: TextStyle(color: Colors.red, fontSize: 14)),
                if (success.isNotEmpty)
                  Text(success,
                      style: TextStyle(color: Colors.green, fontSize: 14)),

                _buildTextField(
                    controller: _emailController,
                    labelText: "Email",
                    icon: Icons.email),
                SizedBox(height: 12),
                _buildTextField(
                    controller: _phonenumberController,
                    labelText: "Phone Number",
                    icon: Icons.phone),
                SizedBox(height: 12),

                // Travel Agency Dropdown
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton<String>(
                    hint: Text("Select your travel agency",
                        style: TextStyle(color: Colors.black)),
                    value: selectedAgency.isEmpty ? null : selectedAgency,
                    isExpanded: true,
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    onChanged: (value) =>
                        setState(() => selectedAgency = value ?? ''),
                    items: agencies.map<DropdownMenuItem<String>>((agency) {
                      return DropdownMenuItem<String>(
                        value: agency['id'].toString(),
                        child: Text(agency['name'],
                            style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 12),

                _buildTextField(
                    controller: _agentNameController,
                    labelText: "Agent Name",
                    icon: Icons.person),
                SizedBox(height: 12),
                _buildTextField(
                    controller: _passwordController,
                    labelText: "Password",
                    icon: Icons.lock,
                    obscureText: true),
                SizedBox(height: 12),
                _buildTextField(
                    controller: _confirmPasswordController,
                    labelText: "Confirm Password",
                    icon: Icons.lock,
                    obscureText: true),
                SizedBox(height: 20),

                // Signup Button (Orange color)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE96C06), // Orange button
                    foregroundColor: Colors.white, // White text
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: loading ? null : _signUp,
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Sign Up", style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),

                // Login Navigation
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Already have an account? Login",
                      style: TextStyle(color: Colors.black)),
                ),

                SizedBox(
                    height:
                        40), // Added space at the bottom for better centering
              ],
            ),
          ),
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
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: Color(0xFFE96C06)), // Orange icons
        filled: true,
        fillColor: Colors.grey[100], // Light background
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black, width: 2),
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
