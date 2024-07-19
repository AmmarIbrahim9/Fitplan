// import 'package:flutter/material.dart';
//
// class SecondScreen extends StatelessWidget {
//   String? email;
//   String? password;
//   String? username;
//
//   SecondScreen({
//     this.email,
//     this.password,
//     this.username,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         // title: const Text('First Screen'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.all(10),
//                   child: const Text(
//                     'Sign Up',
//                     style: TextStyle(
//                         color: Colors.teal,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 30),
//                   )),
//               const SizedBox(height: 20),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Username',
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                   border: OutlineInputBorder(),
//                   prefixIcon: Align(
//                     widthFactor: 1.0,
//                     heightFactor: 1.0,
//                     child: Icon(
//                       Icons.person,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 onChanged: (newValue) {
//                   email = newValue;
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                   border: OutlineInputBorder(),
//                   prefixIcon: Align(
//                     widthFactor: 1.0,
//                     heightFactor: 1.0,
//                     child: Icon(
//                       Icons.email,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//               TextFormField(
//                 onChanged: (newpass) {
//                   password = newpass;
//                 },
//                 //obscureText: _isObscure,
//                 decoration: const InputDecoration(
//                   //suffixIcon: IconButton(icon:Icon(Icons.done), onPressed: () {_isObscure==true? false: true;},),
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Align(
//                     widthFactor: 1.0,
//                     heightFactor: 1.0,
//                     child: Icon(
//                       Icons.password,
//                     ),
//                   ),
//                 ),
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
//               const SizedBox(height: 10),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     /*-------------*/
//                   },
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                   child: Container(
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.all(18),
//                     width: 300,
//                     child: const Text('Sign up', style: TextStyle(fontSize: 20)),
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
