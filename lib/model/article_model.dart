import 'source_model.dart';

class Article {
  Source source;
  String ? author;
  String ? title;
  String ? description;
  String ? url;
  String ? urlToImage;
  String ? publishedAt;
  String ? content;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    print('Parsing Article from JSON: $json');
    final source = Source.fromJson(json['source'] ?? {});
    final author = json['author'] ?? '';
    final title = json['title'] ?? '';
    final description = json['description'] ?? '';
    final url = json['url'] ?? '';
    final urlToImage = json['urlToImage'] ?? '';
    final publishedAt = json['publishedAt'] ?? '';
    final content = json['content'] ?? '';

    print('Parsed Source: $source');
    print('Parsed Author: $author');
    print('Parsed Title: $title');
    print('Parsed Description: $description');
    print('Parsed URL: $url');
    print('Parsed URL To Image: $urlToImage');
    print('Parsed Published At: $publishedAt');
    print('Parsed Content: $content');

    return Article(
      source: source!,
      author: author!,
      title: title!,
      description: description!,
      url: url!,
      urlToImage: urlToImage!,
      publishedAt: publishedAt!,
      content: content!,
    );
  }

}
