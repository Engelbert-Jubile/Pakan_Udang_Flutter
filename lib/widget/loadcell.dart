import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoadCellCard extends StatefulWidget {
  const LoadCellCard({super.key});

  @override
  State<LoadCellCard> createState() => _LoadCellCardState();
}

class _LoadCellCardState extends State<LoadCellCard> {
    DatabaseReference refSensor = FirebaseDatabase.instance.ref('Sensor');

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sisa Pakan Saat Ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            StreamBuilder(
                              stream: refSensor.onValue,
                              builder: (context, snap) {
                               if (snap.hasData && !snap.hasError && snap.data?.snapshot.value != null) {
                              
                              Map data = snap.data?.snapshot.value as Map<dynamic, dynamic>;
                              List item = [];
                             return  Text(
                              '${data["loadcell"]} gram', // Ganti dengan data berat aktual
                              style: TextStyle(
                                fontSize: 16,
                              ));

        
                             
                               } else {
                                      return Text("Loading...");
                               }
                            }
            
            ),
          ],
        ),
      ),
    );
  }
}
