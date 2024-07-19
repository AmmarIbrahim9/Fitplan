// import 'package:flutter/material.dart';
//
// class CustomSearchDelegate extends SearchDelegate {
//   List<String> searchTerms = [
//     "Mac",
//     "iPhone",
//     "Smart Watch",
//     "Lenovo Laptop",
//     "Airpods",
//     "Headset",
//   ];
//
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: const Icon(Icons.clear),
//       ),
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon: const Icon(Icons.arrow_back),
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     List<String> matching = [];
//     for (var item in searchTerms) {
//       if (item.toLowerCase().contains(query.toLowerCase())) {
//         matching.add(item);
//       }
//     }
//     return ListView.builder(
//       itemCount: matching.length,
//       itemBuilder: (context, index) {
//         var result = matching[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<String> matching = [];
//     for (var item in searchTerms) {
//       if (item.toLowerCase().contains(query.toLowerCase())) {
//         matching.add(item);
//       }
//     }
//     return ListView.builder(
//       itemCount: matching.length,
//       itemBuilder: (context, index) {
//         var result = matching[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }
