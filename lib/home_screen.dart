import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app_aibuzz/home_screen_controller.dart';
import 'package:news_app_aibuzz/session_manage.dart';
import 'package:news_app_aibuzz/webview_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final NewsController controller = Get.put(NewsController());

  Future<void> _logout() async {
    await SessionManager.clearLoginSession();
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchNews(); // Fetch news on load

    return DefaultTabController(
      length: 2, // 2 tabs: News & Bookmarks
      child: Scaffold(
        appBar: AppBar(
          title: const Text("News App"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.article), text: "News"),
              Tab(icon: Icon(Icons.bookmark), text: "Bookmarks"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- NEWS TAB ---
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.articles.length,
                itemBuilder: (context, index) {
                  final article = controller.articles[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: article.urlToImage != ''
                          ? Image.network(
                              article.urlToImage,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : null,
                      title: Text(article.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(article.description),
                          const SizedBox(height: 5),
                          Text(
                            '${article.sourceName} • ${article.publishedAt}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        onPressed: () {
                          controller.addBookmark(article);
                          Get.snackbar('Bookmark', 'Bookmark Added !!',backgroundColor: const Color.fromARGB(255, 210, 208, 208));
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebViewPage(url: article.url),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),

            // --- BOOKMARKS TAB ---
            // Center(child: Text("No bookmarks yet"))
            Obx(() {
              final bookmarks = controller.bookmarks;
              if (bookmarks.isEmpty) {
                return const Center(child: Text("No bookmarks yet"));
              }
              return ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final article = bookmarks[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: article.urlToImage != ''
                          ? Image.network(
                              article.urlToImage,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : null,
                      title: Text(article.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(article.description),
                          const SizedBox(height: 5),
                          Text(
                            '${article.sourceName} • ${article.publishedAt}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          controller.removeBookmark(article);
                          Get.snackbar('Bookmark', 'Bookmark Removed !!',backgroundColor: const Color.fromARGB(255, 210, 208, 208));
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebViewPage(url: article.url),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
