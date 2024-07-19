// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fitplanv_1/forgotpasswordpage.dart';
// import 'package:fitplanv_1/signup.dart';
// import 'package:fitplanv_1/userinput/userinput.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:fitplanv_1/user_input.dart';
//
//
//
// class FirstScreen extends StatefulWidget {
//   @override
//   FirstScreenState createState() => FirstScreenState();
// }
//
// class FirstScreenState extends State<FirstScreen> {
//
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool _isObscure = true;
//   String errorMessage = '';
//
//   late FirebaseAuth auth = FirebaseAuth.instance;
//   late GoogleSignIn googleSignIn = GoogleSignIn();
//
//   Future<void> signInWithEmailAndPassword() async {
//     try {
//       if (!mounted) return; // Check if the widget is still mounted
//
//       await auth.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//
//       if (!mounted) return; // Check again after asynchronous operation
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => UserInput()),
//       );
//     } on FirebaseAuthException catch (e) {
//       if (!mounted) return; // Check if the widget is still mounted
//
//       setState(() {
//         errorMessage = getFriendlyErrorMessage(e.code);
//       });
//       _showErrorSnackbar(errorMessage);
//     }
//   }
//
//
//
//
//   Future<void> signInWithGoogle() async {
//     try {
//       // Attempt to sign in without user interaction (if a previous sign-in exists)
//       GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
//
//       // If sign-in silently fails or no user is signed in, prompt the user to select an account
//       if (googleUser == null) {
//         googleUser = await googleSignIn.signIn();
//       }
//
//       // Once we have a Google user account, get the authentication credentials
//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         await auth.signInWithCredential(credential);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => UserInput()),
//         );
//       } else {
//         // Handle case where user cancels or doesn't select an account
//         _showErrorSnackbar('No Google account selected');
//       }
//     } catch (e) {
//       print('Error signing in with Google: $e');
//       _showErrorSnackbar('Failed to sign in with Google');
//     }
//   }
//
//   String getFriendlyErrorMessage(String errorCode) {
//     switch (errorCode) {
//       case 'invalid-email':
//         return 'The email address is badly formatted.';
//       case 'user-not-found':
//         return 'No user found with this email.';
//       case 'wrong-password':
//         return 'Incorrect password. Please try again.';
//       case 'user-disabled':
//         return 'This user has been disabled.';
//       case 'too-many-requests':
//         return 'Too many login attempts. Please try again later.';
//       default:
//         return 'Incorrect password or email.';
//     }
//   }
//
//
//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('asset/loggingg.jpeg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).size.height * 0.45,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 25),
//                     child: Column(
//                       children: [
//                         const Align(
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             'Login',
//                             style: TextStyle(
//                               fontSize: 43.2,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.start,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         TextField(
//                           controller: emailController,
//                           style: const TextStyle(color: Colors.black),
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 20.0, horizontal: 20.0),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20.0),
//                             ),
//                             prefixIcon: const Align(
//                               widthFactor: 1.0,
//                               heightFactor: 1.0,
//                               child: Icon(Icons.email),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 25),
//                         TextField(
//                           controller: passwordController,
//                           style: const TextStyle(),
//                           obscureText: _isObscure,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20.0),
//                             ),
//                             prefixIcon: const Align(
//                               widthFactor: 1.0,
//                               heightFactor: 1.0,
//                               child: Icon(Icons.lock),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _isObscure
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isObscure = !_isObscure;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => Forgetpasswordpage(),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               'Forgot Password?',
//                               style: TextStyle(
//                                 decoration: TextDecoration.underline,
//                                 color: Color(0xff4c505b),
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 40),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//
//                             const SizedBox(width: 10),
//                             SizedBox(
//                               width: 60,
//                               height: 60,
//                               child: ElevatedButton(
//                                 onPressed: signInWithGoogle,
//                                 style: ElevatedButton.styleFrom(
//                                   shape: const CircleBorder(),
//                                   backgroundColor: Colors.transparent,
//                                   padding: const EdgeInsets.all(0),
//                                 ),
//                                 child: Ink.image(
//                                   image: const AssetImage(
//                                     'asset/google-1088004_1280.webp',
//                                   ),
//                                   width: 100,
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 130),
//                             ElevatedButton(
//                               style: ButtonStyle(
//                                 elevation: MaterialStateProperty.all(0),
//                                 side: MaterialStateProperty.all(
//                                     BorderSide(color: Colors.white)),
//                                 backgroundColor:
//                                 MaterialStateProperty.all(Colors.transparent),
//                                 shape: MaterialStateProperty.all(
//                                   RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                 ),
//                               ),
//                               onPressed: signInWithEmailAndPassword,
//                               child: const Padding(
//                                 padding: EdgeInsets.all(10),
//                                 child: Text(
//                                   'Login',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     fontSize: 29,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => Signup(),
//                                   ),
//                                 );
//                               },
//                               child: const Row(
//                                 children: [
//                                   Text(
//                                     'New here? ',
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                       decoration: TextDecoration.none,
//                                       color: Color(0xffffffff),
//                                       fontSize: 24,
//                                     ),
//                                   ),
//                                   Text(
//                                     'Sign Up',
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                       decoration: TextDecoration.none,
//                                       color: Color(0xff000000),
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 24,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
