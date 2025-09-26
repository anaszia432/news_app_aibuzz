import 'package:intl/intl.dart';
import 'dart:convert';

class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String sourceName;
  final String publishedAt;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.sourceName,
    required this.publishedAt,
  });


  factory Article.fromJson(Map<String, dynamic> json) {
   
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(json['publishedAt'] ?? '');
    } catch (e) {
      dateTime = DateTime.now();
    }

    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      sourceName: json['source']?['name'] ?? '',
      publishedAt: DateFormat('d MMMM, yyyy').format(dateTime),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'sourceName': sourceName,
      'publishedAt': publishedAt,
    };
  }

  //  Create Article from JSON stored in SharedPreferences
  factory Article.fromJsonPrefs(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      sourceName: json['sourceName'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}
