import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pakan_udang/pages/login.dart';
import 'package:pakan_udang/widget/camera.dart';
import 'package:pakan_udang/widget/blower.dart';
import 'package:pakan_udang/widget/pakan.dart';
import 'package:pakan_udang/widget/pakan2.dart';
import 'package:pakan_udang/widget/pakan3.dart';
import 'package:pakan_udang/widget/pakan4.dart';
import 'package:pakan_udang/widget/pakan5.dart';
import 'package:pakan_udang/widget/loadcell.dart'; // Import LoadCellCard

void _logout(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Menutup dialog tanpa logout
            },
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut(); // Logout Firebase Auth
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const LoginPage()), // Kembali ke halaman login
              );
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TimeOfDay _selectedTime1 = TimeOfDay(hour: 05,minute: 00);
  TimeOfDay _selectedTime2 = TimeOfDay(hour: 12,minute: 00);
  TimeOfDay _selectedTime3 = TimeOfDay(hour: 16,minute: 00);
  TimeOfDay _selectedTime4 = TimeOfDay(hour: 19,minute: 00);
  TimeOfDay _selectedTime5 = TimeOfDay(hour: 23,minute: 00);
  // DatabaseReference refSensor = FirebaseDatabase.instance.ref('Sensor');

  Future<void> _selectTime(BuildContext context, TimeOfDay _selectedTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        initialEntryMode: TimePickerEntryMode.dialOnly);

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        print(_selectedTime.format(context));
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("PADANG (PAKAN UDANG) OTOMATIS"),
          backgroundColor: Color.fromARGB(255, 211, 71, 6), // Ubah warna AppBar
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.timer)),
              Tab(icon: Icon(Icons.camera_alt_rounded)),
              Tab(icon: Icon(Icons.lightbulb)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PakanCard(),
            CameraCard(), // Tampilkan CameraCard di Tab 2
            Column(
              // Tab untuk menampilkan Lampu, LoadCell, dan TinggiAirCard
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LampuCard(),
                LoadCellCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
