import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/StorageHomePage.dart';

class StorageAccountDetailsPage extends StatefulWidget {
  final String token;

  const StorageAccountDetailsPage({Key? key, required this.token}) : super(key: key);

  @override
  _StorageAccountDetailsPageState createState() =>
      _StorageAccountDetailsPageState();
}

class _StorageAccountDetailsPageState
    extends State<StorageAccountDetailsPage> {
  GoogleMapController? mapController;

  // Variables to hold location data
  double? latitude;
  double? longitude;
  String? sublocality;

  TextEditingController storageOwnerController = TextEditingController();
  TextEditingController storageNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController storageContactController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController rateController = TextEditingController();

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
      builder: (context) =>
          Container(
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
          sublocality =
          "Unknown"; // Handle errors by setting sublocality to "Unknown"
        });
      }
    });
  }

  void _saveDetails() async {
    String storageOwner = storageOwnerController.text;
    String storageName = storageNameController.text;
    String address = addressController.text;
    String storageContact = storageContactController.text;
    String capacity = capacityController.text;
    String rate = rateController.text;

    // Validate input fields
    if (storageOwner.isEmpty || storageName.isEmpty || capacity.isEmpty ||
        rate.isEmpty) {
      _showValidationDialog('Please fill in all the details.');
      return;
    }

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'token': widget.token,
      'storage_name': "$storageName",
      'owner_name': "$storageOwner",
      'address': {
        'type': 'Point',
        'coordinates': [
          longitude ?? 0, // Ensure to handle null values appropriately
          latitude ?? 0,
        ],
        'Sublocality': sublocality ?? '',
        // Sublocality obtained from reverse geocoding
      },
      'storage_contact': "$storageContact",
      'capacity': "$capacity",
      'rate': "$rate",
    };

    // Send the POST request
    try {
      final response = await http.post(
        Uri.parse('http://192.168.76.126:4000/api/v1/auth/StorageInfo'),
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
            MaterialPageRoute(builder: (context) =>
                StorageHomePage(userId: data['storage']['user'])),
          );
        } else {
          // Handle server response indicating failure
          print(data['message']);
        }
      } else {
        // Handle server errors
        print(
            'Failed to save storage information. Server returned status code ${response
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
        title: Text('Storage Account Details',
            style: TextStyle(color: Colors.white)), // Set app bar text color
        backgroundColor: Colors.black87, // Change app bar backgr
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Storage Owner:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: storageOwnerController,
                decoration: InputDecoration(
                  hintText: 'Enter Storage owner',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Storage Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: storageNameController,
                decoration: InputDecoration(
                  hintText: 'Enter Storage name',
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _showMapPicker(context);
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: addressController,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    maxLines: 5,
                    minLines: 2,
                    enabled: false,
                    cursorColor: Color.fromARGB(255, 252, 139, 26),
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.add_location_alt_outlined,
                        color: Color.fromARGB(255, 252, 139, 26),
                      ),
                      alignLabelWithHint: true,
                      labelText: 'Address ',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 104, 104, 104),
                        fontSize: 16,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color.fromARGB(255, 252, 139, 26),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color.fromARGB(255, 252, 139, 26),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Storage Contact:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: storageContactController,
                decoration: InputDecoration(
                  hintText: 'Enter Storage contact number',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Capacity:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: capacityController,
                decoration: InputDecoration(
                  hintText: 'Enter Capacity',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Rate:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: rateController,
                decoration: InputDecoration(
                  hintText: 'Enter Rate',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveDetails();
                },
                child: Text('Save', style: TextStyle(color: Colors.white)),
                // Set button text color
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black45, // Set button color to black45
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}