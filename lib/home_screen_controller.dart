import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:news_app_aibuzz/model/news_article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'news_article_model.dart';

class NewsController extends GetxController {
  var articles = <Article>[].obs;
  var isLoading = false.obs;
  var bookmarks = <Article>[].obs;

   @override
  void onInit() {
    super.onInit();
    fetchNews();
    loadBookmarks();
  }

  //  BOOKMARK data 
  
  void addBookmark(Article article) {
    if (!bookmarks.any((a) => a.url == article.url)) {
      bookmarks.add(article);
      saveBookmarks();
    }
  }

  void removeBookmark(Article article) {
    bookmarks.removeWhere((a) => a.url == article.url);
    saveBookmarks();
  }

  Future<void> saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarkStrings =
        bookmarks.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList('bookmarks', bookmarkStrings);
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? bookmarkStrings = prefs.getStringList('bookmarks');
    if (bookmarkStrings != null) {
      bookmarks.value =
          bookmarkStrings.map((s) => Article.fromJson(jsonDecode(s))).toList();
    }
  }


  final Dio dio = Dio();
  final String apiKey = '8ed31e92fee54210a1ddc3ef81c0733a'; 

  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'category': 'business',
          'apiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        List data = response.data['articles'];
        articles.value = data.map((e) => Article.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load news');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print( e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
