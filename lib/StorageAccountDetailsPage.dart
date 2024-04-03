import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageAccountDetailsPage extends StatefulWidget {
  const StorageAccountDetailsPage({Key? key}) : super(key: key);

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

  TextEditingController storageNameController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController storageContactController = TextEditingController();

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

  void _saveDetails() {
    String storageName = storageNameController.text;
    String ownerName = ownerNameController.text;
    String address = addressController.text;
    String storageContact = storageContactController.text;

    // Perform validation if necessary

    // Save details to database or perform any other action
    print('Storage Name: $storageName');
    print('Owner Name: $ownerName');
    print('Address: $address');
    print('Storage Contact: $storageContact');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    print('Sublocality: $sublocality');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storage Account Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Storage Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: storageNameController,
                decoration: InputDecoration(
                  hintText: 'Enter storage name',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Owner Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: ownerNameController,
                decoration: InputDecoration(
                  hintText: 'Enter owner name',
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
                  hintText: 'Enter storage contact number',
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
