import 'package:flutter/material.dart';

void main() {
  runApp(FarmerApp());
}

class FarmerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmer App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FarmerHomePage(),
    );
  }
}

class FarmerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FarmerButton(
              buttonText: 'Agricultural News',
              onPressed: () {
                // Navigate to Agricultural News page
              },
            ),
            SizedBox(height: 20),
            FarmerButton(
              buttonText: 'Price Prediction',
              onPressed: () {
                // Navigate to Price Prediction page
              },
            ),
            SizedBox(height: 20),
            FarmerButton(
              buttonText: 'Disease Detection',
              onPressed: () {
                // Navigate to Disease Detection page
              },
            ),
            SizedBox(height: 20),
            FarmerButton(
              buttonText: 'Map Gateway',
              onPressed: () {
                // Navigate to Map Gateway page
              },
            ),
          ],
        ),
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
      child: Text(buttonText),
    );
  }
}
