import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NurseryHomePage extends StatefulWidget {
  final String userId;

  NurseryHomePage({required this.userId});

  @override
  _NurseryHomePageState createState() => _NurseryHomePageState();
}

class _NurseryHomePageState extends State<NurseryHomePage> {
  late Future<List<dynamic>> _futureNurseryInfo;
  late Future<List<dynamic>> _futureNurseryStock;
  late String nurseryId;

  @override
  void initState() {
    super.initState();
    _futureNurseryInfo = fetchNurseryInfoByUserId(widget.userId);
    _futureNurseryInfo.then((nurseryInfo) {
      if (nurseryInfo.isNotEmpty) {
        setState(() {
          nurseryId = nurseryInfo[0]['_id'] as String;
          _futureNurseryStock = getAllNurseryStockUsers(nurseryId)!; // Ensure initialization
        });
      }
    });
  }



  Future<List<dynamic>> fetchNurseryInfoByUserId(String userId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.76.126:4000/api/v1/auth/getnurserybyid?userId=$userId'));

      if (response.statusCode == 200) {
        var nurseryInfo = json.decode(response.body) as List<dynamic>;
        return nurseryInfo;
      } else {
        throw Exception('Failed to load nursery information');
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> createNurseryStock(String nurseryId, String varieties, int quantity, double price) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.76.126:4000/api/v1/auth/createnurserystock'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nursery': nurseryId,
          'varieties': varieties,
          'quantity': quantity,
          'price': price,
        }),
      );
      print(response.body);

      if (response.statusCode == 201) {
        // Successfully created
        setState(() {
          // Refresh nursery information after creation
          _futureNurseryInfo = fetchNurseryInfoByUserId(widget.userId);
        });
      } else {
        throw Exception('Failed to create nursery stock');
      }
    } catch (error) {
      // Handle error
      print(error);
    }
  }

  Future<void> updateNurseryStock(String id, String varieties, int quantity, double price) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.76.126:4000/api/v1/auth/updatenurserystock/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'varieties': varieties,
          'quantity': quantity,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully updated
        setState(() {
          // Refresh nursery information after update
          _futureNurseryInfo = fetchNurseryInfoByUserId(widget.userId);
        });
      } else {
        throw Exception('Failed to update nursery stock');
      }
    } catch (error) {
      // Handle error
      print(error);
    }
  }

  void _showUpdateDialog(Map<String, dynamic> stock) {
    showDialog(
      context: context,
      builder: (context) {
        String varieties = stock['varieties'];
        int quantity = stock['quantity'];
        double price = stock['price'];
        return AlertDialog(
          title: Text('Update Nursery Stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: varieties,
                onChanged: (value) {
                  varieties = value;
                },
                decoration: InputDecoration(labelText: 'Varieties'),
              ),
              TextFormField(
                initialValue: quantity.toString(),
                onChanged: (value) {
                  quantity = int.tryParse(value) ?? quantity;
                },
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextFormField(
                initialValue: price.toString(),
                onChanged: (value) {
                  price = double.tryParse(value) ?? price;
                },
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancel update
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call update function
                _updateNurseryStock(stock['_id'], varieties, quantity, price);
                Navigator.pop(context); // Close dialog
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateNurseryStock(String _id, String varieties, int quantity, double price) {
    // Implement update functionality
    updateNurseryStock(_id, varieties, quantity, price).then((_) {
      // After successful update, refresh nursery stock
      _futureNurseryStock = getAllNurseryStockUsers(nurseryId);
    });
  }

  void _deleteStockUser(String _id) {
    // Implement delete functionality
    deleteNurseryStock(_id).then((_) {
      // After successful deletion, refresh nursery stock
      _futureNurseryStock = getAllNurseryStockUsers(nurseryId);
    });
  }

  void _showAddStockUserDialog() {
    String varieties = '';
    int quantity = 0;
    double price = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Nursery Stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (value) {
                  varieties = value;
                },
                decoration: InputDecoration(labelText: 'Varieties'),
              ),
              TextFormField(
                onChanged: (value) {
                  quantity = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextFormField(
                onChanged: (value) {
                  price = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(labelText: 'Price'),
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
                // Call function to create nursery stock
                await createNurseryStock(nurseryId, varieties, quantity, price);
                Navigator.pop(context); // Close the dialog
                setState(() {
                  // Refresh nursery stock after adding a new stock
                  _futureNurseryStock = getAllNurseryStockUsers(nurseryId);
                });
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteNurseryStock(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.76.126:4000/api/v1/auth/deletenurserystock/$id'),
      );

      if (response.statusCode == 200) {
        // Successfully deleted
        setState(() {
          // Refresh nursery stock information after deletion
          _futureNurseryStock = getAllNurseryStockUsers(nurseryId);
        });
      } else {
        throw Exception('Failed to delete nursery stock');
      }
    } catch (error) {
      // Handle error
      print(error);
    }
  }

  Future<List<dynamic>> getAllNurseryStockUsers(String nurseryId) async {
    try {
      final url = Uri.parse(
          'http://192.168.76.126:4000/api/v1/auth/getallnurserystock/$nurseryId');
      print('Request URL: $url');

      final response = await http.get(url);
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var nurseryStocks = data['nurseryStock'] as List<dynamic>;
        return nurseryStocks;
      } else {
        throw Exception('Failed to fetch nursery stock users');
      }
    } catch (error) {
      // Handle error
      print(error);
      return []; // Return an empty list if an error occurs
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nursery Home Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Welcome to your Nursery!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
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
                    // Replace Image.network with your nursery image widget
                    Image.network(
                      'https://res.cloudinary.com/dss6gmp9i/image/upload/v1714514792/nursery_nkx2mv.webp',
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Placeholder(
                          fallbackHeight: 200,
                          fallbackWidth: MediaQuery.of(context).size.width,
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _showAddStockUserDialog,
                      child: Text('Add Nursery Stock'),
                    ),
                    FutureBuilder(
                      future: _futureNurseryStock, // Use _futureNurseryStock here
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<dynamic>? stockUsers = snapshot.data as List<dynamic>?;

                          if (stockUsers == null || stockUsers.isEmpty) {
                            return Text('No nursery stock users available.');
                          }

                          return Column(
                            children: stockUsers.map((user) {
                              return ListTile(
                                title: Text('Stock User ID: ${user['_id']}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Varieties: ${user['varieties']}'),
                                    Text('Quantity: ${user['quantity']}'),
                                    Text('Price: ${user['price']}'),
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
                                        _deleteStockUser(user['_id']);
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
