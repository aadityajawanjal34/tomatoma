import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreApp extends StatelessWidget {
  final String userId;

  StoreApp({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(userId: userId),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  List<String> nurseries = [];
  List<String> storages = [];
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCoordinates();
  }

  // Method to fetch coordinates based on user ID
  Future<void> fetchCoordinates() async {
    try {
      final url = Uri.parse(
          'http://192.168.76.126:4000/api/v1/auth/fetchcoordfarmer?userId=${widget
              .userId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final coordinates = responseData['coordinates'];

        setState(() {
          latitude = coordinates[1];
          longitude = coordinates[0];
        });

        fetchNurseries();
        fetchStorages();
      } else {
        print('Failed to load coordinates: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching coordinates: $error');
    }
  }

  Future<void> fetchNurseries() async {
    try {
      final url = Uri.parse(
          'http://192.168.76.126:4000/api/v1/auth/nearNurseries?longitude=$longitude&latitude=$latitude');
      final response = await http.get(
          url, headers: {'Content-Type': 'application/json'});

      print('Nurseries Response: ${response.body}'); // Print response

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData.containsKey('nurseries')) {
          setState(() {
            nurseries = responseData['nurseries'].map<String>((nursery) {
              // Initialize nurseryInfo with basic details
              String nurseryInfo =
                  'Name: ${nursery['nursery_name']}, Owner: ${nursery['nursery_owner']}, Contact: ${nursery['nursery_contact']}';

              // Check if nurseryStock is not empty
              if (nursery['nurseryStock'] != null && nursery['nurseryStock'].isNotEmpty) {
                // Add nursery stock details to nurseryInfo
                nurseryInfo += '\nStock: ';
                nursery['nurseryStock'].forEach((stockItem) {
                  nurseryInfo +=
                  '\nVariety: ${stockItem['varieties']}, Quantity: ${stockItem['quantity']}, Price: ${stockItem['price']}';
                });
              } else {
                // Add message for no stock available
                nurseryInfo += '\nStock: No stock available';
              }

              // Check if nursery has rating and review
              if (nursery['ratingAndReview'] != null) {
                nurseryInfo +=
                ', Rating: ${nursery['ratingAndReview']['rating']}, Review: ${nursery['ratingAndReview']['review']}';
              }
              // Return the nurseryInfo string
              return nurseryInfo;
            }).toList();
          });

          // Clear previous markers
          // markers.clear();

          // Add markers for nurseries
          for (var nursery in responseData['nurseries']) {
            print('Adding marker for nursery: ${nursery['nursery_name']}');

            // Extract coordinates from the 'address' field
            dynamic address = nursery['address'];
            if (address != null && address['coordinates'] != null) {
              List<dynamic>? coordinates = address['coordinates'];
              if (coordinates != null && coordinates.length >= 2) {
                double? nurseryLatitude = coordinates[1] as double?;
                double? nurseryLongitude = coordinates[0] as double?;

                if (nurseryLatitude != null && nurseryLongitude != null) {
                  // Define nurseryInfo here and use it in InfoWindow
                  String nurseryInfo = nurseries.firstWhere((n) => n.contains(nursery['nursery_name']));
                  markers.add(
                    Marker(
                      markerId: MarkerId(nursery['nursery_name']),
                      position: LatLng(nurseryLatitude, nurseryLongitude),
                      infoWindow: InfoWindow(
                        title: nursery['nursery_name'],
                        snippet: 'Owner: ${nursery['nursery_owner']}',
                        onTap: () {
                          // Show the full nursery information when the marker is tapped
                          showNurseryInfoDialog(nurseries.firstWhere((n) => n.contains(nursery['nursery_name'])));
                        },
                      ),
                    ),
                  );

                  // Add debugging statement for when marker is added
                  print('Marker added for nursery: ${nursery['nursery_name']}');
                } else {
                  print('Invalid coordinates for nursery: ${nursery['nursery_name']}');
                }
              } else {
                print('Invalid coordinates for nursery: ${nursery['nursery_name']}');
              }
            } else {
              print('Invalid address data for nursery: ${nursery['nursery_name']}');
            }
          }

          // Update the map
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(latitude, longitude),
              12.0,
            ),
          );

          // Add debugging statement for when markers are added on the map
          print('Markers added on the map: ${markers.length}');
        } else {
          print('Failed to load nurseries');
        }
      } else {
        print('Failed to load nurseries: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching nurseries: $error');
    }
  }



// Method to fetch nearby storages based on coordinates
  Future<void> fetchStorages() async {
    try {
      final url = Uri.parse(
          'http://192.168.76.126:4000/api/v1/auth/nearStorages?longitude=$longitude&latitude=$latitude');
      final response = await http.get(
          url, headers: {'Content-Type': 'application/json'});

      print('Storages Response: ${response.body}'); // Print response

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData.containsKey('storages')) {
          setState(() {
            storages = responseData['storages'].map<String>((storage) {
              String storageInfo =
                  'Name: ${storage['storage_name']}, Owner: ${storage['owner_name']}, Contact: ${storage['storage_contact']}';
              return storageInfo;
            }).toList();
          });

          // Clear previous markers
          // markers.clear();

          // Add markers for storages
          for (var storage in responseData['storages']) {
            print('Adding marker for storage: ${storage['storage_name']}');

            // Extract coordinates from the 'address.coordinates' field
            List<dynamic>? coordinates = storage['address']['coordinates'];
            if (coordinates != null && coordinates.length >= 2) {
              double storageLongitude = coordinates[0] as double;
              double storageLatitude = coordinates[1] as double;

              markers.add(
                Marker(
                  markerId: MarkerId(storage['storage_name']),
                  position: LatLng(storageLatitude, storageLongitude),
                  infoWindow: InfoWindow(
                    title: storage['storage_name'],
                    snippet: 'Owner: ${storage['owner_name']}',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Change marker color to blue
                ),
              );

              // Add debugging statement for when marker is added
              print('Marker added for storage: ${storage['storage_name']}');
            } else {
              print('Invalid coordinates for storage: ${storage['storage_name']}');
            }
          }

          // Update the map
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(latitude, longitude),
              12.0,
            ),
          );
        } else {
          print('Failed to load storages');
        }
      } else {
        print('Failed to load storages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching storages: $error');
    }
  }




  // Function to fetch details of a nursery by its name
  Future<void> fetchNurseryDetails(Map<String, dynamic> nursery) async {
    try {
      final url = Uri.parse(
          'http://192.168.212.126:4000/api/v1/auth/nursery/info?nurseryName=${nursery['nursery_name']}');

      print('Request URL: $url'); // Print request URL

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Print response data for debugging
        print('Response Data: $responseData');

        // Display fetched details using a dialog or another widget
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Create a list of ListTile widgets to display each key-value pair
            List<Widget> listTiles = [];

            // Iterate over the responseData map
            responseData.forEach((key, value) {
              // Add a ListTile for each key-value pair
              listTiles.add(
                ListTile(
                  title: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(value.toString()),
                ),
              );
            });

            // Return the AlertDialog with the ListView containing the listTiles
            return AlertDialog(
              title: Text('Nursery Details'),
              content: SingleChildScrollView(
                child: Column(
                  children: listTiles,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to fetch nursery details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching nursery details: $error');
    }
  }

// Function to fetch details of a storage by its name
  Future<void> fetchStorageDetails(String storageName) async {
    print(storageName);
    try {
      final url = Uri.parse(
          'http://192.168.76.126:4000/api/v1/auth/storage/info?storageName=$storageName');
      final response = await http.get(url);

      print(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Display fetched details using a dialog or another widget
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Create a list of ListTile widgets to display each key-value pair
            List<Widget> listTiles = [];

            // Iterate over the responseData map
            responseData.forEach((key, value) {
              // Add a ListTile for each key-value pair
              listTiles.add(
                ListTile(
                  title: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(value.toString()),
                ),
              );
            });

            // Return the AlertDialog with the ListView containing the listTiles
            return AlertDialog(
              title: Text('Storage Details'),
              content: SingleChildScrollView(
                child: Column(
                  children: listTiles,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },

        );
      } else {
        print('Failed to fetch storage details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching storage details: $error');
    }
  }

  // Method to display nursery stock details dialog
  Future<void> showNurseryStockDialog(List<dynamic> nurseryStock) async {
    // Display fetched details using a dialog or another widget
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a list of ListTile widgets to display each nursery stock item
        List<Widget> listTiles = [];

        // Iterate over the nursery stock list
        nurseryStock.forEach((stockItem) {
          // Add a ListTile for each nursery stock item
          listTiles.add(
            ListTile(
              title: Text(
                'Variety: ${stockItem['varieties']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Quantity: ${stockItem['quantity']}, Price: ${stockItem['price']}'),
            ),
          );
        });

        // Return the AlertDialog with the ListView containing the listTiles
        return AlertDialog(
          title: Text('Nursery Stock'),
          content: SingleChildScrollView(
            child: Column(
              children: listTiles,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
// Add a method to display a dialog with the full nursery information
  Future<void> showNurseryInfoDialog(String nurseryInfo) async {
    // Display nursery information using a dialog or another widget
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nursery Information'),
          content: SingleChildScrollView(
            child: Text(nurseryInfo),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
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
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: fetchNurseries,
            icon: Icon(Icons.spa),
            color: Colors.white,
          ),
          IconButton(
            onPressed: fetchStorages,
            icon: Icon(Icons.storage),
            color: Colors.white,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 12.0,
        ),
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),

    );
  }
}