// import 'login.dart';
// import 'package:flutter/material.dart';
//
//
//
//
// class MyLogin extends StatefulWidget {
//   const MyLogin({Key? key}) : super(key: key);
//
//   @override
//   _MyLoginState createState() => _MyLoginState();
// }
//
// class _MyLoginState extends State<MyLogin> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('asset/Fitplan.jpeg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             padding: const EdgeInsets.all(70.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return FirstScreen();
//                     },
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 side: const BorderSide(color: Colors.black26, width: 2), // Set border color and width
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.only(left: 45,top: 25,right: 45,bottom: 25),
//                 child: Text(
//                   'Get Started',
//                   style: TextStyle(
//                     fontSize: 24.0,
//                     fontFamily: '',
//                     color: Color(0xFF4FA676),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }