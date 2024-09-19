import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakan_udang/pages/home.dart';
import 'dart:async';
import 'package:pakan_udang/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus(); // Pastikan ini berjalan di dalam initState
  }

  void _checkUserStatus() {
    User? user = FirebaseAuth.instance.currentUser;

    // Penggunaan Future.delayed untuk penundaan
    Future.delayed(const Duration(seconds: 2), () {
      if (user != null) {
        // Lakukan navigasi setelah penundaan pendek
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/assets/udang_icon.png', // Ubah path sesuai dengan path gambar udang Anda
              width: 200,
              height: 100,
            ),
            Text(
              "PAKAN UDANG OTOMATIS",
              style: TextStyle(
                color: Color.fromARGB(255, 211, 71, 6),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Copyright by Pakan Udang Otomatis ",
              style: TextStyle(fontSize: 12),
            ),
          ],
        )));
  }
}
