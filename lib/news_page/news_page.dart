// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
//
// class NewsService {
//   static const String _baseUrl = 'https://newsapi.org/v2/';
//   static const String _apiKey = '715c96d189954291a07e60371df49d30';
//
//   Future<List<dynamic>> fetchNews(String category, {String language = 'en'}) async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl/top-headlines?category=$category&language=$language&apiKey=$_apiKey'),
//     );
//
//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       return jsonData['articles'];
//     } else {
//       throw Exception('Failed to load news');
//     }
//   }
// }
//
// class NewsPage extends StatefulWidget {
//   @override
//   _NewsPageState createState() => _NewsPageState();
// }
//
// class _NewsPageState extends State<NewsPage> {
//   final NewsService _newsService = NewsService();
//   List<dynamic> _articles = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchNews();
//   }
//
//   Future<void> _fetchNews() async {
//     try {
//       final healthArticles = await _newsService.fetchNews('health', language: 'en');
//       final dietArticles = await _newsService.fetchNews('health', language: 'ar');
//       setState(() {
//         _articles = [...healthArticles, ...dietArticles];
//       });
//     } catch (e) {
//       print('Error fetching news: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Health & Diet News'),
//       ),
//       body: _articles.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _articles.length,
//         itemBuilder: (context, index) {
//           final article = _articles[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: GestureDetector(
//                 onTap: () async {
//                   final url = article['url'];
//                   if (await canLaunch(url)) {
//                     await launch(url);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Could not launch $url'),
//                       ),
//                     );
//                   }
//                 },
//                 child: ListTile(
//                   title: Text(
//                     article['title'] ?? 'No Title',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     article['description'] ?? 'No Description',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: NewsPage(),
//   ));
// }
