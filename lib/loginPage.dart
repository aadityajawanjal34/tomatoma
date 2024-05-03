
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
    var width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      body: Form(
        key: _signInFormKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "HELLO, WELCOME AGAIN!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Changed color to black
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                  child: Divider(
                    thickness: 2,
                    color: Colors.black54,
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
                                color: Colors.black45, // Changed color to red
                              ),
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: const TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent),
                                  // Transparent border
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent),
                                  // Transparent border
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
                                  return 'Enter your UserName';
                                }
                                return null;
                              },
                              controller: passwordController,
                              obscureText: true,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black45, // Changed color to red
                              ),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Colors.black45,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't Have an Account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Changed color to black
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EmailInputPage(),
                                ));
                              },
                              child: Text(
                                'Register Here',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_signInFormKey.currentState!.validate()) {
                              String email = emailController.text;
                              String password = passwordController.text;

                              try {
                                var response = await http.post(
                                  Uri.parse(
                                      'http://192.168.76.126:4000/api/v1/auth/login'),
                                  headers: {'Content-Type': 'application/json'},
                                  body: jsonEncode(
                                      {'email': email, 'password': password}),
                                );

                                Map<String, dynamic> data = jsonDecode(
                                    response.body);

                                if (response.statusCode == 200 &&
                                    data['success']) {
                                  var user = data['user'];
                                  var token = data['token'];

                                  String accountType = user['accountType'];
                                  print(accountType);
                                  switch (accountType) {
                                    case 'Farmer':
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            FarmerHomePage(userId: user['_id'])),
                                      );
                                      break;
                                    case 'Nursery':
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            NurseryHomePage(userId: user['_id'])),
                                      );
                                      break;
                                    case 'Storage':
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            StorageHomePage(userId: user['_id'])),
                                      );
                                      break;
                                    default:
                                    // Handle unknown account type
                                      break;
                                  }
                                } else {
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'An error occurred. Please try again later.'),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            // Set the background color to black
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50), // Rounded button
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Container(
                              height: 50,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  'SignIn',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
}