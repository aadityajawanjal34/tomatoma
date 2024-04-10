
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'EmailInputImage.dart';
import 'FarmerHomePage.dart';
import 'NurseryHomePage.dart';
import 'StorageHomePage.dart';
import 'constants.dart';
import 'signupPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final AuthServices authService = AuthServices();
  final _signInFormKey = GlobalKey<FormState>();
  bool isApiCall = false;
  bool hidepass = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? pass;
  String? username;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  // void signInUser() {
  //   authService.signInUser(
  //     context: context,
  //     email: emailController.text,
  //     password: passwordController.text,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _signInFormKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            // radius: 0.7,
                            colors: [
                              Colors.redAccent,
                              kLogTColour,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),

                          // color: kLogTColour,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(width / 3),
                              bottomLeft: Radius.circular(width / 3))),
                      child: Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.android,
                            color: kLogTColour,
                            size: 80,
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment(-1, -1),
                  child: Flexible(
                      flex: 1,
                      child: Text(
                        "Hello, \nWelcome Again",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: kLogTColour),
                      )),
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
                                  borderRadius: BorderRadius.circular(20)),
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: "Email",
                                    labelStyle: const TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    )
                                    //hintTextDirection: TextDirection.rtl,
                                    ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: kLogTextfiled,
                                  border: Border.all(color: Colors.white54),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Enter your UserName';
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
                                        borderRadius: BorderRadius.circular(20))
                                    //hintTextDirection: TextDirection.rtl,
                                    ),
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't Have an Account? ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kLogTColour),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailInputPage()));
                              },
                              child: Text(
                                'Register Here',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),


                      ElevatedButton(
                    style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent)),
          onPressed: () async {
            if (_signInFormKey.currentState!.validate()) {
              // Retrieve email and password from text controllers
              String email = emailController.text;
              String password = passwordController.text;
              print(email);
              print(password);

              try {
                // Send login request to backend server
                var response = await http.post(
                  Uri.parse('http://localhost:4000/api/v1/auth/login'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'email': email, 'password': password}),

                );
                print(response);

                // Parse response body
                Map<String, dynamic> data = jsonDecode(response.body);

                // Check if login was successful
                if (response.statusCode == 200 && data['success']) {
                  // Retrieve user data and token
                  var user = data['user'];
                  var token = data['token'];


                  // Navigate based on account type
                  String accountType = user['accountType'];
                  print (accountType);
                  switch(accountType) {
                    case 'Farmer':
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FarmerHomePage()),
                      );
                      break;
                    case 'Nursery':
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => NurseryHomePage()),
                      );
                      break;
                    case 'Storage':
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => StorageHomePage()),
                      );
                      break;
                    default:
                    // Handle unknown account type
                      break;
                  }
                } else {
                  // Handle login failure
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Login Failed'),
                        content: Text(data['message']),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              } catch (error) {
                // Handle network or server errors
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('An error occurred. Please try again later.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 30, horizontal: 50),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.redAccent, kLogTColour],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("SignIn"),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
          ),
        ),


        ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
