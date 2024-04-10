import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'NurseryAccountDetailsPage.dart';
import 'StorageAccountDetailsPage.dart';
import 'constants.dart';
import 'farmer_account_details_page.dart';
import 'package:file_picker/file_picker.dart'; // Import the file_picker package

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _signUpFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? selectedAccountType;
  String? otp;
  String? certificatePath; // Variable to store the path of the selected certificate file

  Future<void> _signUp() async {
    if (_signUpFormKey.currentState!.validate()) {
      // Form validation succeeded, send signup request to backend
      final url = Uri.parse('http://localhost:4000/api/v1/auth/signup');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
          'confirmPassword': confirmPasswordController.text,
          'accountType': selectedAccountType ?? '',
          'otp': otp ?? '',
        }),
      );

      if (response.statusCode == 200) {
        // Signup successful, parse the response and extract the token
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the token from the response
        final token = responseData['user']['token'];

        print(responseData); // Print the parsed response data for debugging
        print(token);

        // Store the token for future use, you can use shared preferences, secure storage, or any other method
        // For example, you can use the flutter_secure_storage package
        // Import the package: import 'package:flutter_secure_storage/flutter_secure_storage.dart';
        // Then store the token:
        // final storage = FlutterSecureStorage();
        // await storage.write(key: 'token', value: token);

        // Navigate to account details page or perform any other action
        navigateToAccountDetailsPage(token);
      } else {
        // Signup failed, show error message
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Signup Failed'),
                content: Text('Failed to signup. Please try again later.'),
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
  }


  void _pickCertificate() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      // Store the file path
      setState(() {
        certificatePath = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      body: Form(
        key: _signUpFormKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.redAccent,
                          kLogTColour,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(width / 3),
                        bottomLeft: Radius.circular(width / 3),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.android,
                          color: kLogTColour,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment(-1, -1),
                  child: Flexible(
                    flex: 1,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: kLogTColour,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                  child: Divider(
                    thickness: 2,
                    color: Colors.redAccent,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kLogTextfiled,
                              border: Border.all(color: Colors.white54),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter your Email';
                                }
                                return null;
                              },
                              controller: emailController,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: "Email",
                                labelStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kLogTextfiled,
                              border: Border.all(color: Colors.white54),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter your Password';
                                }
                                return null;
                              },
                              controller: passwordController,
                              obscureText: true,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kLogTextfiled,
                              border: Border.all(color: Colors.white54),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter your Password Again';
                                }
                                return null;
                              },
                              controller: confirmPasswordController,
                              obscureText: true,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // OTP Field
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kLogTextfiled,
                              border: Border.all(color: Colors.white54),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter OTP';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                otp = val; // Update the OTP value
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                labelText: 'OTP',
                                labelStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Account Type Dropdown
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kLogTextfiled,
                              border: Border.all(color: Colors.white54),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Select your Account Type';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Account Type',
                                labelStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              value: selectedAccountType,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedAccountType = newValue;
                                });
                              },
                              items: <String>[
                                'Farmer',
                                'Nursery',
                                'Storage',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        // Certificate upload button
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: _pickCertificate,
                            child: Text('Upload Certificate'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kLogTColour,
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: _signUp,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToAccountDetailsPage(String token) {
    if (selectedAccountType == 'Farmer') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FarmerAccountDetailsPage(token: token)));
    }
    else if (selectedAccountType == 'Nursery') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NurseryAccountDetailsPage(token: token)));
    }
    else if (selectedAccountType == 'Storage') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StorageAccountDetailsPage(token: token)));
    }
  }
}

