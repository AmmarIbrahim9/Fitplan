// // main.dart
//
// import 'package:fitplanv_1/homepage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
//
// class Lab {
//   final String name;
//   final String status;
//   final double rating;
//   final String operatingHours;
//   final String thumbnailUrl;
//   final bool hasBranches;
//
//   Lab({
//     required this.name,
//     required this.status,
//     required this.rating,
//     required this.operatingHours,
//     required this.thumbnailUrl,
//     required this.hasBranches,
//   });
// }
//
// class Labs extends StatelessWidget {
//   final List<Lab> labs = [
//     Lab(
//       name: 'Revamp Alpha Lab',
//       status: 'Open Now',
//       rating: 4.5,
//       operatingHours: '11 am - 11 pm',
//       thumbnailUrl: 'https://th.bing.com/th/id/OIP.UGRNmHY7S0_xWjjlrGQ1xgAAAA?rs=1&pid=ImgDetMain',
//       hasBranches: true,
//     ),
//     Lab(
//       name: 'Almokhtaber Lab',
//       status: 'Closed Now',
//       rating: 4.7,
//       operatingHours: '(9 am - 5 pm)',
//       thumbnailUrl: 'https://dreamadvancedprojectsegypt.com/assets/images/964362_0.jpg',
//       hasBranches: true,
//     ),
//     Lab(
//       name: 'AlBorg Lab',
//       status: 'Closed Now',
//       rating: 4.7,
//       operatingHours: '(9 am - 5 pm)',
//       thumbnailUrl: 'https://th.bing.com/th/id/OIP.ifBblevILQxaBNs8k_N7UgEsEs?w=166&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
//       hasBranches: true,
//     ),
//     Lab(
//       name: 'Medlab',
//       status: 'Closed Now',
//       rating: 4.7,
//       operatingHours: '(9 am - 5 pm)',
//       thumbnailUrl: 'https://th.bing.com/th/id/OIP.Qn4fJsTpL0pXtg5ke4W8hgHaHa?w=151&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
//       hasBranches: true,
//     ),
//     // Add other labs here...
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Lab Search App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: LabListScreen(labs: labs),
//     );
//   }
// }
//
// class LabListScreen extends StatefulWidget {
//   final List<Lab> labs;
//
//   LabListScreen({required this.labs});
//
//   @override
//   _LabListScreenState createState() => _LabListScreenState();
// }
//
// class _LabListScreenState extends State<LabListScreen> {
//   List<Lab> filteredLabs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     filteredLabs = widget.labs;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) {
//                   return FitPlanHomePage();
//                 },
//               ),
//             );
//           },
//         ),
//         title: Text('Lab Search'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'Search Lab',
//                 suffixIcon: Icon(Icons.search, color: Colors.green),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   filteredLabs = widget.labs.where((lab) {
//                     return lab.name.toLowerCase().contains(value.toLowerCase());
//                   }).toList();
//                 });
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredLabs.length,
//               itemBuilder: (context, index) {
//                 final lab = filteredLabs[index];
//                 int offerPercentage = calculateOfferPercentage(lab.rating);
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: ListTile(
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         lab.thumbnailUrl,
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => LabDetailsPage(lab: lab),
//                           ),
//                         );
//                       },
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               lab.name,
//                               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Container(
//                             width: 20,
//                             height: 20,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: lab.status == 'Open Now' ? Colors.green : Colors.red,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Text(
//                               lab.status,
//                               style: TextStyle(color: lab.status == 'Open Now' ? Colors.green : Colors.red, fontSize: 16),
//                             ),
//                             SizedBox(width: 10),
//                             Text(
//                               lab.operatingHours,
//                               style: TextStyle(color: Colors.black54, fontSize: 16),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           'Rating: ${lab.rating} (${offerPercentage}% off)',
//                           style: TextStyle(color: Colors.black87, fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class LabDetailsPage extends StatelessWidget {
//   final Lab lab;
//
//   LabDetailsPage({required this.lab});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(lab.name),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.map),
//             onPressed: () {
//               // Implement navigation to map view
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Status: ${lab.status}', style: TextStyle(fontSize: 18, color: lab.status == 'Open Now' ? Colors.green : Colors.red)),
//             SizedBox(height: 8),
//             Text('Rating: ${lab.rating}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Text('Operating Hours: ${lab.operatingHours}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 8),
//             Text('Branches Available: ${lab.hasBranches ? 'Yes' : 'No'}', style: TextStyle(fontSize: 18)),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Implement call functionality
//         },
//         backgroundColor: Colors.green,
//         child: Icon(Icons.call, size: 28),
//       ),
//     );
//   }
// }
//
// int calculateOfferPercentage(double rating) {
//   if (rating > 4.5) {
//     return 15;
//   } else if (rating >= 4.0 && rating <= 4.4) {
//     return 10;
//   } else {
//     return 5;
//   }
// }
// void main() => runApp(Labs());
