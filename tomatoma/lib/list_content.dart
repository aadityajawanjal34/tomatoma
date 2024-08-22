import 'package:flutter/material.dart';

class ListContent extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final String imagePath;

  ListContent({required this.text, required this.onClick, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return TextButton( // Use TextButton instead of FlatButton
      onPressed: onClick,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(8.0)),
      ),
      child: ListTile(
        leading: Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.fill),
        title: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
