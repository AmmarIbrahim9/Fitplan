// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(Test());
// }
//
// class Test extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Auth Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Auth Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FutureBuilder<User?>(
//               future: _getUser(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else {
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   } else if (snapshot.hasData && snapshot.data != null) {
//                     User? user = snapshot.data;
//                     return Column(
//                       children: [
//                         Text(
//                           'Logged in as:',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Email: ${user!.email}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'User ID: ${user.uid}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 8),
//                         ElevatedButton(
//                           onPressed: () {
//                             FirebaseAuth.instance.signOut();
//                           },
//                           child: Text('Sign Out'),
//                         ),
//                       ],
//                     );
//                   } else {
//                     return Text('User not logged in');
//                   }
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<User?> _getUser() async {
//     try {
//       User? currentUser = FirebaseAuth.instance.currentUser;
//       return currentUser;
//     } catch (e) {
//       print('Error fetching user: $e');
//       return null;
//     }
//   }
// }
