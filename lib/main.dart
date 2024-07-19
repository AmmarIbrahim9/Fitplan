import 'package:firebase_core/firebase_core.dart';

import 'to be deleted/details.dart';
import 'splash_screen.dart';
import 'package:fitplanv_1/splash_screen.dart';
import 'package:flutter/material.dart';
import 'to be deleted/products.dart';
import 'to be deleted/Search.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDZ2r6-WdLiFRaSh4OV6xFbsdajGSisK1U',
        appId: '1:155421108316:android:fecda8640f95000deade99',
        messagingSenderId: '155421108316',
        projectId: 'fitplan-ab9f0',
        storageBucket: 'fitplan-ab9f0.appspot.com',
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
