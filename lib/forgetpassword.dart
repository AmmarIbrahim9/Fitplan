import 'package:flutter/material.dart';


class Forgetpassword extends StatelessWidget {
  String? email;

  TextEditingController passwordController = TextEditingController();

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
                  image: AssetImage('asset/Forgetpass.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.145,
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
                            'Enter new password',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          height: 190,
                        ),
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            //suffixIcon: IconButton(icon:Icon(Icons.done), onPressed: () {_isObscure==true? false: true;},),
                            labelText: 'Enter your new password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(
                                Icons.password,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          style: const TextStyle(),
                          obscureText: true,
                          decoration: InputDecoration(
                            //suffixIcon: IconButton(icon:Icon(Icons.done), onPressed: () {_isObscure==true? false: true;},),
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(
                                Icons.password,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),

                            ElevatedButton(
                              onPressed: () {

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF249056),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                side: const BorderSide(color: Colors.black26, width: 1), // Set border color and width
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 45,top: 20,right: 45,bottom: 20),
                                child: Text(
                                  'Set new password',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontFamily: '',
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     TextButton(
                        //       onPressed: () {
                        //         Navigator.pushNamed(context, 'register');
                        //       },
                        //       child: Text(
                        //         'Sign Up',
                        //         textAlign: TextAlign.left,
                        //         style: TextStyle(
                        //           decoration: TextDecoration.underline,
                        //           color: Color(0xff4c505b),
                        //           fontSize: 18,
                        //         ),
                        //       ),
                        //       style: ButtonStyle(),
                        //     ),
                        //     CircleAvatar(
                        //       radius: 30,
                        //       backgroundColor: Color(0xff4FA676),
                        //       child: IconButton(
                        //         color: Colors.white,
                        //         onPressed: () {},
                        //         icon: Icon(
                        //           Icons.login,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
