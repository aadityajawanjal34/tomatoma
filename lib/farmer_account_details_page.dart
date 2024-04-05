import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(FarmerAccountDetailsPage());
}

class FarmerAccountDetailsPage extends StatefulWidget {
  const FarmerAccountDetailsPage({Key? key}) : super(key: key);

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
    } else if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
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
    );
  }

  void _saveDetails() async {
    String name = nameController.text;
    String contact = contactController.text;

    // Validate input fields
    if (name.isEmpty || contact.isEmpty || latitude == null || longitude == null) {
      _showValidationDialog('Please fill in all the details.');
      return;
    }

    // Reverse geocode the selected location to get the address
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);
      if (placemarks.isNotEmpty) {
        sublocality = placemarks[0].subLocality ?? placemarks[0].locality;
      }
    } catch (e) {
      print('Error getting address: $e');
    }

    // Save details to database or perform any other action
    print('Name: $name');
    print('Contact: $contact');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    print('Sublocality: $sublocality');

    // Navigate to FarmerHomePage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FarmerHomePage()),
    );
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
                child: AbsorbPointer(
                  child: TextField(
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
                      labelText: 'Location ',
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

class FarmerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Home Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to Farmer Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
