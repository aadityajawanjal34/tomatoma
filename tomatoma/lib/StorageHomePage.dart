import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorageHomePage extends StatefulWidget {
  final String userId;

  StorageHomePage({required this.userId});

  @override
  _StorageHomePageState createState() => _StorageHomePageState();
}

class _StorageHomePageState extends State<StorageHomePage> {
  late Future<List<dynamic>> _futureStorageInfo;
  late Future<List<dynamic>> _futureStorageStockUsers;
  late String storageId; // Define storageId here
  @override
  void initState() {
    super.initState();
    _futureStorageInfo = fetchStorageInfoByUserId(widget.userId);
    _futureStorageInfo.then((storageInfo) {
      // Assuming the first item in the list contains the storage info
      if (storageInfo.isNotEmpty) {
        storageId = storageInfo[0]['_id'] as String; // Assign storageId here
        _futureStorageStockUsers = getAllStorageStockUsers(storageId);
      }
    });
  }


  Future<List<dynamic>> fetchStorageInfoByUserId(String userId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.76.126:4000/api/v1/auth/getstoragebyid?userId=$userId'));

      if (response.statusCode == 200) {
        var storageInfo = json.decode(response.body) as List<dynamic>;
        return storageInfo;
      } else {
        throw Exception('Failed to load storage information');
      }
    } catch (error) {
      // Handle error
      print(error);
      rethrow; // Re-throwing the error for higher-level handling
    }
  }

  Future<void> createStorageStockUser(String storageId, String farmer,
      int period,
      int capacity) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.76.126:4000/api/v1/auth/createstockuser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'storage': storageId, // Use storageId here
          'farmer': farmer,
          'period': period,
          'capacity': capacity,
        }),
      );

      if (response.statusCode == 201) {
        // Successfully created
        setState(() {
          // Refresh storage information after creation
          _futureStorageInfo = fetchStorageInfoByUserId(widget.userId);
        });
      } else {
        throw Exception('Failed to create storage stock user');
      }
    } catch (error) {
      // Handle error
      print(error);
    }
  }


  Future<void> updateStorageStockUser(String id, String farmer, int period,
      int capacity) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.76.126:4000/api/v1/auth/updatestockuser/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'farmer': farmer,
          'period': period,
          'capacity': capacity,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully updated
        setState(() {
          // Refresh storage information after update
          _futureStorageInfo = fetchStorageInfoByUserId(widget.userId);
        });
      } else {
        throw Exception('Failed to update storage stock user');
      }
    } catch (error) {
      // Handle error
      print(error);
    }
  }

  void _showUpdateDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        String farmer = user['farmer'];
        int period = user['period'];
        int capacity = user['capacity'];
        return AlertDialog(
          title: Text('Update Stock User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: farmer,
                onChanged: (value) {
                  farmer = value;
                },
                decoration: InputDecoration(labelText: 'Farmer'),
              ),
              TextFormField(
                initialValue: period.toString(),
                onChanged: (value) {
                  period = int.tryParse(value) ?? period;
                },
                decoration: InputDecoration(labelText: 'Period'),
              ),
              TextFormField(
                initialValue: capacity.toString(),
                onChanged: (value) {
                  capacity = int.tryParse(value) ?? capacity;
                },
                decoration: InputDecoration(labelText: 'Capacity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call update function
                _updateStockUser(user['_id'], farmer, period, capacity);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateStockUser(String _id, String farmer, int period, int capacity) {
    // Implement update functionality
    updateStorageStockUser(_id, farmer, period, capacity).then((_) {
      // After successful update, refresh storage stock users
      _futureStorageStockUsers = getAllStorageStockUsers(storageId);
    });
  }

  void _deleteStockUser(String _id) {
    // Implement delete functionality
    deleteStorageStockUser(_id).then((_) {
      // After successful deletion, refresh storage stock users
      _futureStorageStockUsers = getAllStorageStockUsers(storageId);
    });
  }

  void _showAddStockUserDialog() {
    String farmer = '';
    int period = 0;
    int capacity = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Storage Stock User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (value) {
                  farmer = value;
                },
                decoration: InputDecoration(labelText: 'Farmer'),
              ),
              TextFormField(
                onChanged: (value) {
                  period = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Period'),
              ),
              TextFormField(
                onChanged: (value) {
                  capacity = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Capacity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call function to create storage stock user
                await createStorageStockUser(
                    storageId, farmer, period, capacity);
                Navigator.pop(context); // Close the dialog
                setState(() {
                  // Refresh storage stock users after adding a new user
                  _futureStorageStockUsers = getAllStorageStockUsers(storageId);
                });
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }


  Future<void> deleteStorageStockUser(String id) async {
    try {
      final response = await http.delete(
          Uri.parse('http://192.168.76.126:4000/api/v1/auth/deletestockuser/$id'));

      if (response.statusCode == 200) {
        // Successfully deleted
        setState(() {
          // Refresh storage information after deletion
          _futureStorageInfo = fetchStorageInfoByUserId(widget.userId);
        });
      } else {
        throw Exception('Failed to delete storage stock user');
      }
    } catch (error) {
      // Handle error
      print(error);
    }
  }

  Future<List<dynamic>> getAllStorageStockUsers(String storageId) async {
    try {
      final url = Uri.parse(
          'http://192.168.76.126:4000/api/v1/auth/getallstockuser/$storageId');
      print('Request URL: $url');

      final response = await http.get(url);
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body)['storageStockUsers'];
      } else {
        throw Exception('Failed to fetch storage stock users');
      }
    } catch (error) {
      // Handle error
      print(error);
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storage Home Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                'Welcome to your Storage!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.network(
                      'https://res.cloudinary.com/dss6gmp9i/image/upload/v1714514791/Storage_Facility_In_Mumbai_hwwdm2.jpg',
                      height: 200,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Placeholder(
                          fallbackHeight: 200,
                          fallbackWidth: MediaQuery
                              .of(context)
                              .size
                              .width,
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    FutureBuilder(
                      future: _futureStorageInfo,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<dynamic>? storageInfo = snapshot.data as List<
                              dynamic>?;

                          if (storageInfo == null || storageInfo.isEmpty) {
                            return Center(child: Text(
                                'No storage information available.'));
                          }

                          return Column(
                            children: storageInfo.map((storage) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        'Storage Name: ${storage['storage_name']}'),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                            'Owner Name: ${storage['owner_name']}'),
                                        Text(
                                            'Storage Contact: ${storage['storage_contact']}'),
                                        Text(
                                            'Address: ${storage['address']['Sublocality']}'),
                                        Text(
                                            'Capacity: ${storage['capacity']}'),
                                        Text('Rate: ${storage['rate']}'),
                                        if (storage['ratingAndReview'] != null)
                                          Text(
                                              'Rating and Review: ${storage['ratingAndReview']}'),
                                      ],
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: _futureStorageStockUsers,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        List<dynamic>? stockUsers = snapshot
                                            .data as List<dynamic>?;

                                        if (stockUsers == null ||
                                            stockUsers.isEmpty) {
                                          return Text(
                                              'No storage stock users available.');
                                        }

                                        return Column(
                                          children: stockUsers.map((user) {
                                            return ListTile(
                                              title: Text(
                                                  'Stock User ID: ${user['_id']}'),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                      'Farmer: ${user['farmer']}'),
                                                  Text(
                                                      'Period: ${user['period']}'),
                                                  Text(
                                                      'Capacity: ${user['capacity']}'),
                                                ],
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      _showUpdateDialog(user);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      _deleteStockUser(
                                                          user['_id']);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20.0), // Added margin for spacing
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 3.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _showAddStockUserDialog,
                        child: Text(
                          'Add Storage Stock User',
                          style: TextStyle(color: Colors.white), // Set text color to white
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black45, // Set background color to black45
                          elevation: 0, // Remove elevation
                          padding: EdgeInsets.symmetric(vertical: 15.0), // Added padding for better appearance
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}