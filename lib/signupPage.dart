import 'package:flutter/material.dart';

import 'NurseryAccountDetailsPage.dart';
import 'StorageAccountDetailsPage.dart';
import 'constants.dart';
import 'farmer_account_details_page.dart';

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
  TextEditingController farmerNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController farmerContactController = TextEditingController();
  String? selectedAccountType;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    farmerNameController.dispose();
    addressController.dispose();
    farmerContactController.dispose();
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
                          onPressed: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              // Process signup logic here
                              // After successful signup, navigate based on account type
                              navigateToAccountDetailsPage();
                            }
                          },
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

  void navigateToAccountDetailsPage() {
    if (selectedAccountType == 'Farmer') {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FarmerAccountDetailsPage()));
    } else if (selectedAccountType == 'Nursery') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NurseryAccountDetailsPage()));
    } else if (selectedAccountType == 'Storage') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => StorageAccountDetailsPage()));
    }
  }

}