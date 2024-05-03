import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/api_service.dart';

import 'components/customListTile.dart';
import 'model/article_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService client = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "NEWS CORNER",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8), // Add spacing between title and icon
              Image.network(
                'https://res.cloudinary.com/dss6gmp9i/image/upload/v1714514791/newstoma_nffr0u.png',
                height: 34, // Adjust the height as needed
                width: 24, // Adjust the width as needed
              ),
            ],
          ),
          backgroundColor: Colors.teal[500],
          centerTitle: true, // Center align the title
          actions: [
            IconButton(
              icon: Icon(Icons.search), // Example search icon
              onPressed: () {
                // Add onPressed callback for the icon if needed
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: client.getArticle(),
            builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (snapshot.hasData) {
                List<Article>? articles = snapshot.data;
                return ListView.builder(
                  itemCount: articles?.length,
                  itemBuilder: (context, index) =>
                      customListTile(articles![index], context),
                );
              } else {
                return Center(
                  child: Text("No data available"),
                );
              }
            },
            ),
        );
    }
}
