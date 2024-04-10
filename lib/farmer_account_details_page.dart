import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'FarmerHomePage.dart';

class FarmerAccountDetailsPage extends StatefulWidget {
  final String token;

  const FarmerAccountDetailsPage({Key? key, required this.token}) : super(key: key);

  @override
  _FarmerAccountDetailsPageState createState() =>
      _FarmerAccountDetailsPageState();
}

class _FarmerAccountDetailsPageState extends State<FarmerAccountDetailsPage> {
  GoogleMapController? mapController;

  // Variables to hold location data
  double? latitude;
  double? longitude;
  String? sublocality;

  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      // Handle denied permissions
      _showPermissionDeniedDialog();
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission Denied"),
          content: Text(
              "Location permission is required to use this feature. Please enable location permission in your device settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showMapPicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude ?? 0, longitude ?? 0),
            zoom: 14,
          ),
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
          markers: Set.from([
            if (latitude != null && longitude != null)
              Marker(
                markerId: MarkerId("currentLocation"),
                position: LatLng(latitude!, longitude!),
              ),
          ]),
          onTap: (latLng) {
            setState(() {
              latitude = latLng.latitude;
              longitude = latLng.longitude;
              mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
            });
          },
        ),
      ),
    ).then((value) async {
      // After the modal bottom sheet is closed, fetch the address details and update the UI
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            latitude!, longitude!);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          String? subLocality = placemark.subLocality ?? placemark.locality;
          setState(() {
            sublocality = subLocality ?? "Unknown";
          });
        } else {
          setState(() {
            sublocality = "Unknown"; // Set a default value for sublocality
          });
        }
      } catch (e) {
        print('Error getting address: $e');
        setState(() {
          sublocality = "Unknown"; // Handle errors by setting sublocality to "Unknown"
        });
      }
    });
  }



  void _saveDetails() async {
    String name = nameController.text;
    String contact = contactController.text;

    // Validate input fields
    if (name.isEmpty || contact.isEmpty || latitude == null ||
        longitude == null) {
      _showValidationDialog('Please fill in all the details.');
      return;
    }

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'token': widget.token,
      'farmer_name': "$name",
      'address': {
        'type': 'Point',
        'coordinates': [
          longitude ?? 0, // Ensure to handle null values appropriately
          latitude ?? 0,
        ],
        'Sublocality': sublocality ?? '', // Sublocality obtained from reverse geocoding
      },
      'farmer_contact': "$contact",
    };


    // Send the POST request
    try {
      final response = await http.post(
        Uri.parse('http://localhost:4000/api/v1/auth/farmerInfo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      print('token=${widget.token}');
      print(jsonEncode(requestBody));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success']) {
          // Successfully saved farmer information
          print(data['message']);
          // Navigate to FarmerHomePage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FarmerHomePage()),
          );
        } else {
          // Handle server response indicating failure
          print(data['message']);
        }
      } else {
        // Handle server errors
        print(
            'Failed to save farmer information. Server returned status code ${response
                .statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error occurred while communicating with the server: $e');
    }
  }

  void _showValidationDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Account Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Farmer Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _showMapPicker(context);
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            sublocality != null
                                ? sublocality!
                                : 'Select a location',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Contact:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(
                  hintText: 'Enter your contact number',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveDetails();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}