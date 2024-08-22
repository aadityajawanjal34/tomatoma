import 'dart:convert';
import 'package:untitled/model/article_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final endPointUrl =
      "http://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=ea8138e93b7345b6a91425ba6e3fa9b8";

  Future<List<Article>> getArticle() async {
    try {
      // Parse the endpoint URL string into a Uri object
      Uri endpointUri = Uri.parse(endPointUrl);

      // Make the HTTP GET request using the Uri object
      http.Response res = await http.get(endpointUri);

      // Check if the response status code indicates success
      if (res.statusCode == 200) {
        // Check if the response body is not null
        if (res.body != null) {
          print('Response Body: ${res.body}');

          // Parse the JSON response
          Map<String, dynamic> json = jsonDecode(res.body);

          print('Parsed JSON: $json');

          // Extract the 'articles' list from the JSON response
          List<dynamic> articlesJson = json['articles'];

          // Map the 'articles' list to a list of Article objects
          List<Article> articles = articlesJson
              .map((dynamic item) => Article.fromJson(item))
              .toList();

          // Check and handle null content
          articles.forEach((article) {
            if (article.content == null) {
              // Handle null content, for example, by assigning a default value
              article.content = "No content available";
            }
          });

          // Return the list of Article objects
          return articles;
        } else {
          throw Exception("Response body is null");
        }
      } else {
        // If the response status code is not 200, throw an exception
        throw Exception('Failed to load articles: ${res.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the HTTP request or JSON parsing, throw an exception
      throw Exception('Failed to load articles: $e');
    }
  }
}
