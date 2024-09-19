import 'package:flutter/material.dart';

class LampuCard extends StatefulWidget {
  @override
  _LampuCardState createState() => _LampuCardState();
}

class _LampuCardState extends State<LampuCard> {
  bool isOn = false; // Status default off

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Tambahkan sedikit shadow
      margin: EdgeInsets.all(10), // Beri sedikit margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              Icons.lightbulb,
              size: 100,
              color: isOn
                  ? Colors.yellow
                  : Colors.grey, // Warna ikon berdasarkan status
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Ubah status on/off ketika tombol ditekan
                  isOn = !isOn;
                });
                // Tambahkan logika untuk menghidupkan/mematikan lampu di sini
              },
              style: ElevatedButton.styleFrom(
                primary: isOn
                    ? Colors.yellow
                    : Colors.grey, // Warna tombol disesuaikan dengan status
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isOn
                    ? 'BLOWER MENYALA'
                    : 'BLOWER MATI', // Ubah teks tombol berdasarkan status
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
