import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Forgetpasswordpage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();

  Future<void> sendOTP(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: emailController.text);
      // Navigate or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      // Handle errors such as invalid email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/Forgotpassword.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.095,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 40, right: 25),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF3D3939),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'San Francisco'
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 250),
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Enter your email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(Icons.email),
                            ),
                          ),
                        ),
                        const SizedBox(height: 70),
                        ElevatedButton(
                          onPressed: () => sendOTP(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF249056),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: const BorderSide(color: Colors.black26, width: 1),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                            child: Text(
                              'Reset password',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: '',
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Modern back button positioned at the top left corner with a little space above it
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black, // You can adjust the color
                    size: 30, // You can adjust the size
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
