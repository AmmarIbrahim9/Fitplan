// import 'package:flutter/material.dart';
//
// class Description extends StatelessWidget {
//   final String Desc;
//   final int id;
//   final String photo;
//   final int quantity;
//
//   const Description(
//       {Key? key,
//       required this.photo,
//       required this.id,
//       required this.Desc,
//       required this.quantity})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Align(alignment: Alignment.center, child: Text('Description')),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.shopping_cart),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 child: Hero(tag: id, child: Image.network(photo)),
//               ),
//               const SizedBox(height: 25),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
//                 child: Container(
//                   height: 2.0,
//                   width: 350.0,
//                   color: Colors.teal,
//                 ),
//               ),
//               const Text('Description :',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
//               Text(Desc, style: const TextStyle(fontSize: 15)),
//               const SizedBox(height: 18),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
//                 child: Container(
//                   height: 2.0,
//                   width: 350.0,
//                   color: Colors.teal,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               Row(children: [
//                 const Text(
//                   'Quantity',
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                 ),
//                 Text(' : $quantity pieces left!',
//                     style: const TextStyle(fontSize: 15)),
//               ]),
//               const SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
//                 child: Container(
//                   height: 2.0,
//                   width: 350.0,
//                   color: Colors.teal,
//                 ),
//               ),
//               Container(
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                     child: Container(
//                       alignment: Alignment.center,
//                       padding: const EdgeInsets.all(18),
//                       width: 300,
//                       child: const Text('Add to cart',
//                           style: TextStyle(fontSize: 20)),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
