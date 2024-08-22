import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/signupPage.dart';

class EmailInputPage extends StatefulWidget {
  @override
  _EmailInputPageState createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final String email = _emailController.text.trim();
    print('Email captured: $email'); // Print the captured email

    final Uri uri = Uri.parse('http://192.168.76.126:4000/api/v1/auth/sendotp');

    // Print the request body
    print('Request body: {"email": "$email"}');

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        // Set the content type explicitly
        body: jsonEncode({"email": "$email"}), // Encode the body as JSON
      );
      print(response.body);

      // Handle response
      if (response.statusCode == 200) {
        // Successful request
        // Navigate to signup page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      } else {
        // Request failed
        // Handle error, maybe show an error message
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Error'),
                content: Text('Failed to send OTP. Please try again later.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      // Error occurred
      // Handle error, maybe show an error message
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(
                  'An unexpected error occurred. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.black45), // Set text color
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black87), // Set label color
                border: OutlineInputBorder( // Add border
                  borderSide: BorderSide(
                      color: Colors.black45), // Set border color
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendOTP,
              child: Text('Send OTP'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.black45), // Set background color
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Set text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    home: EmailInputPage(),
  ));
}
