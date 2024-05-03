import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';


class ClassificationPage extends StatefulWidget {
  @override
  _ClassificationPageState createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  File? _image;
  String? _prediction;

  final picker = ImagePicker();

  Future getImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        final bytes = result.files.single.bytes;
        if (bytes != null) {
          setState(() {
            _image = null; // Reset previous image
            _imageBytes = bytes;
          });
        } else {
          print('No image bytes available.');
        }
      } else {
        print('No image selected.');
      }
    } on PlatformException catch (e) {
      print('Error picking image: $e');
    }
  }

  Uint8List? _imageBytes;
  double? _confidence;


  Future classifyImage() async {
    if (_imageBytes == null) {
      print("No image selected.");
      return;
    }

    String apiUrl = 'http://127.0.0.1:5000/api/v1/predict';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        _imageBytes!,
        filename: 'image.jpg', // Provide a filename for the image
      ),
    );

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = utf8.decode(responseData);
    print(response);
    print(responseData);
    print(responseString);

    setState(() {
      _prediction = json.decode(responseString)['class'];
      _confidence =json.decode(responseString)['confidence'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Classifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageBytes == null
                ? Text('No image selected.')
                : Image.memory(
              _imageBytes!,
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black87, // Set text color to white
              ),
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: classifyImage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black87, // Set text color to white
              ),
              child: Text('Classify Image'),
            ),
            SizedBox(height: 20),
            _prediction == null
                ? Container()
                : Text(
              'Prediction: $_prediction',
              style: TextStyle(fontSize: 20, color: Colors.black), // Set text color to black
            ),
            Text(
              'Confidence: ${(_confidence ?? 0.0) * 100}%', // Convert confidence score to percentage
              style: TextStyle(fontSize: 16, color: Colors.black), // Set text color to black
            ),
          ],
        ),
      ),
    );
  }
}
