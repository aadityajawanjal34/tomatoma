import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/news_page.dart';
import 'package:untitled/price.dart';

import 'Stores.dart';
import 'classification.dart';

class FarmerHomePage extends StatelessWidget {
  final String userId;

  FarmerHomePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WELCOME FARMER!',
          style: TextStyle(
            fontSize: 28, // Increase font size
            fontWeight: FontWeight.bold, // Make it bold
          ),
        ),
        centerTitle: true, // Center the title text
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20), // Add spacing above the image
          Center(
            child: Image.network(
              'https://res.cloudinary.com/dss6gmp9i/image/upload/v1714514791/farmer_aropyh.jpg', // Assuming 'farmer.jpg' is in the 'assets' folder
              width: 200, // Reduce image width
              height: 200, // Reduce image height
            ),
          ),
          SizedBox(height: 20), // Add spacing below the image
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FarmerButton(
                buttonText: 'News',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
                  // Navigate to Agricultural News page
                },
              ),
              SizedBox(height: 10), // Add spacing between buttons
              FarmerButton(
                buttonText: 'Price Prediction',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PricePage()));
                  // Navigate to Price Prediction page

                },
              ),
              SizedBox(height: 10), // Add spacing between buttons
              FarmerButton(
                buttonText: 'Disease Detection',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ClassificationPage()));
                  // Navigate to Disease Detection page
                },
              ),
              SizedBox(height: 10), // Add spacing between buttons
              FarmerButton(
                buttonText: 'Nearest Stores',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StoreApp(userId: userId)));
                  // Navigate to Map Gateway page
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FarmerButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const FarmerButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Set button color to black
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Add padding to the button
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Make text bold
          ),
        ),
      ),
    );
  }
}
