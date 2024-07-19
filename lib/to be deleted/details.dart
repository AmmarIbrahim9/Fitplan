// import '../Description.dart' show Description;
// import '../products.dart';
// import 'package:flutter/material.dart';
//
// class details extends StatefulWidget {
//   const details({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<details> createState() => _detailsState();
// }
//
// class _detailsState extends State<details> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Padding(
//             padding: EdgeInsets.fromLTRB(80.0, 2.0, 3.0, 4.0),
//             child: Text('More Details')),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: GridView.builder(
//           itemCount: productList.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 1,
//             childAspectRatio: 3.5 / 5,
//             crossAxisSpacing: 15,
//           ),
//           itemBuilder: (context, index) {
//             final item = productList[index];
//
//             return GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => Description(
//                           photo: item.image!,
//                           id: item.id!,
//                           Desc: item.description!,
//                           quantity: item.quantity!,
//                         )),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                           child: Hero(
//                               tag: item.id!,
//                               child: Image.network(item.image!))),
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             item.isFavorite = item.isFavorite!;
//                           });
//                         },
//                         child: Align(
//                           alignment: Alignment.topRight,
//                           child: Icon(
//                             item.isFavorite == true
//                                 ? Icons.favorite
//                                 : Icons.favorite_border,
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     item.name!,
//                     style: const TextStyle(fontSize: 20),
//                   ),
//                   Container(
//                       width: double.infinity,
//                       color: Colors.grey.withOpacity(0.8),
//                       child: Center(
//                           child: Text(
//                         '${item.price.toString()} USD',
//                         style: const TextStyle(fontSize: 18),
//                       ))),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
