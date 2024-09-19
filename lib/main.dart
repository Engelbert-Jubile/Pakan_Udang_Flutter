import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pakan_udang/pages/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Penting untuk inisialisasi Firebase
  await Firebase.initializeApp(); // Inisialisasi Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       navigatorKey:globalNavigatorKey, 
      home: SplashScreen(),
    );
  }
}
