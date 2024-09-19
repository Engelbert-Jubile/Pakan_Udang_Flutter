import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Pakan2Card extends StatefulWidget {
  final String waktu;

  const Pakan2Card({super.key, required this.waktu});
  @override
  _Pakan2CardState createState() => _Pakan2CardState();
}

class _Pakan2CardState extends State<Pakan2Card> {
  bool isPakanOn = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      color: isPakanOn
          ? Colors.green
          : Colors
              .grey, // Set background color of the card based on isPakanOn value
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beri Pakan Jam ${widget.waktu}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Change text color to white
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isPakanOn ? 'AKTIF' : 'TIDAK AKTIF',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white, // Change text color to white
                  ),
                ),
                Switch(
                  value: isPakanOn,
                  onChanged: (value) {
                    setState(() {
                      isPakanOn = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
