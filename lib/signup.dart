import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitplanv_1/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isConfirmObscure = true;
  bool _isChecked = false;
  String errorMessage = '';

  Future<void> signUpWithEmailAndPassword() async {
    if (!_isChecked) {
      setState(() {
        errorMessage = 'You must agree to the terms and conditions';
      });
      _showErrorSnackbar(errorMessage);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      _showErrorSnackbar(errorMessage);
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = getFriendlyErrorMessage(e.code);
      });
      _showErrorSnackbar(errorMessage);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FirstScreen()),
          );
        } else {
          _showAccountExistsDialog();
        }
      } else {
        _showErrorSnackbar('Failed to sign in with Google. Please try again.');
      }
    } catch (e) {
      setState(() {
        errorMessage =
            'An error occurred during Google sign-in. Please try again.';
      });
      _showErrorSnackbar(errorMessage);
    }
  }

  void _showAccountExistsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account Exists'),
          content: Text(
              'This Google account is already linked to an existing user. Do you want to sign in with a different account?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Try Different Account'),
              onPressed: () {
                Navigator.of(context).pop();
                signInWithDifferentGoogleAccount();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signInWithDifferentGoogleAccount() async {
    await GoogleSignIn().signOut();
    signInWithGoogle();
  }

  String getFriendlyErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'This email is already in use. Please try another one.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('asset/signup.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.35,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30, right: 25),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 43.2,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(Icons.email),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.black),
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(Icons.lock),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: confirmPasswordController,
                          style: const TextStyle(color: Colors.black),
                          obscureText: _isConfirmObscure,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(Icons.check_box),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmObscure = !_isConfirmObscure;
                                });
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.transparent,
                                // Text color
                                elevation: 0,
                                // Remove the elevation
                                shadowColor:
                                    Colors.transparent, // Remove shadow
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        TermsAndServicesPage(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      var begin = Offset(1.0, 0.0);
                                      var end = Offset.zero;
                                      var curve = Curves.easeInOut;
            
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);
            
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                )
                                    .then((_) {
            // Ensure state is updated when returning
                                  setState(() {});
                                });
                              },
                              child: const Text(
                                'I agree to the terms and conditions',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: signInWithGoogle,
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.all(0),
                                ),
                                child: Ink.image(
                                  image: const AssetImage(
                                    'asset/google-1088004_1280.webp',
                                  ),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 103),
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.white),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: _isChecked
                                  ? signUpWithEmailAndPassword
                                  : () {
                                      _showErrorSnackbar(
                                        'You must agree to the terms and conditions',
                                      );
                                    },
                              child: const Padding(
                                padding: EdgeInsets.all(6.2),
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 29,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
