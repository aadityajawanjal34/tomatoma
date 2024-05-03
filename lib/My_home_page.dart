import 'package:flutter/material.dart';
import 'EmailInputImage.dart';
import 'loginPage.dart';
import 'signupPage.dart'; // Import SignUpPage

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFFFFFF),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Image.network(
                    'https://res.cloudinary.com/dss6gmp9i/image/upload/v1714514791/tomato_fbvhht.png',
                    height: 200, // Reduced image height
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'TOMATOVERSE',
                  style: TextStyle(fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC62828)),
                ),
                SizedBox(height: 8),
                Text(
                  'AI powered one-stop solution',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors
                        .black45, // Set button background color to black45
                  ),
                  child: Text(
                    'Log In',
                    style: TextStyle(fontSize: 16,
                        color: Colors.white), // Set text color to white
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton( // Add the signup button
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EmailInputPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors
                        .black45, // Set button background color to black45
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16,
                        color: Colors.white), // Set text color to white
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
