import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pakan_udang/tool/shrimp.dart';

class Helpers {
  static lin(p1, p2) {
    return math.sqrt(
        math.pow((p2['x'] - p1['x']), 2) + math.pow(p2['y'] - p1['y'], 2));
  }

  static int getUmurUdang(double panjang_udang_cm){
          if (0.000 <= panjang_udang_cm && panjang_udang_cm <= 0.8) {
          return 1;
        } else if (0.80 <= panjang_udang_cm && panjang_udang_cm <= 1.64) {
          return 2;
        } else if (1.65 <= panjang_udang_cm && panjang_udang_cm <= 2.62) {
          return 3;
        } else if (2.63 <= panjang_udang_cm && panjang_udang_cm <= 3.60) {
          return 4;
        } else if (3.61 <= panjang_udang_cm && panjang_udang_cm <= 4.58) {
          return 5;
        } else if (4.59 <= panjang_udang_cm && panjang_udang_cm <= 5.56) {
          return 6;
        } else if (5.57 <= panjang_udang_cm && panjang_udang_cm <= 6.54) {
          return 7;
        } else if (6.55 <= panjang_udang_cm && panjang_udang_cm <= 7.52) {
          return 8;
        } else if (7.53 <= panjang_udang_cm && panjang_udang_cm <= 8.50) {
          return 9;
        } else if (8.51 <= panjang_udang_cm && panjang_udang_cm <= 9.49) {
          return 10;
        } else if (9.50 <= panjang_udang_cm && panjang_udang_cm <= 10.47) {
          return 11;
        } else if (10.48 <= panjang_udang_cm && panjang_udang_cm <= 11.45) {
          return 12;
        } else if (11.46 <= panjang_udang_cm && panjang_udang_cm <= 12.43) {
          return 13;
        } else if (12.44 <= panjang_udang_cm && panjang_udang_cm <= 13.41) {
          return 14;
        } else if (13.42 <= panjang_udang_cm && panjang_udang_cm <= 14.39) {
          return 15;
        } else if (14.40 <= panjang_udang_cm && panjang_udang_cm <= 15.37) {
          return 16;
        } else if (15.38 <= panjang_udang_cm && panjang_udang_cm <= 16.35) {
          return 17;
        } else if (16.36 <= panjang_udang_cm && panjang_udang_cm <= 17.33) {
          return 18;
        } else {
          return 0;
        }
  }

  static double getMbwUdang(int umur_udang){
      if (umur_udang == 1) {
    return 0.001;
  } else if (umur_udang == 2) {
    return 0.76;
  } else if (umur_udang == 3) {
    return 2.09;
  } else if (umur_udang == 4) {
    return 3.42;
  } else if (umur_udang == 5) {
    return 4.75;
  } else if (umur_udang == 6) {
    return 6.08;
  } else if (umur_udang == 7) {
    return 7.41;
  } else if (umur_udang == 8) {
    return 8.74;
  } else if (umur_udang == 9) {
    return 10.07;
  } else if (umur_udang == 10) {
    return 11.40;
  } else if (umur_udang == 11) {
    return 12.73;
  } else if (umur_udang == 12) {
    return 14.06;
  } else if (umur_udang == 13) {
    return 15.39;
  } else if (umur_udang == 14) {
    return 16.72;
  } else if (umur_udang == 15) {
    return 18.05;
  } else if (umur_udang == 16) {
    return 19.38;
  } else if (umur_udang == 17) {
    return 20.71;
  } else if (umur_udang == 18) {
    return 22.04;
  } else {
    return 0.00;
  }
  }

  static double getFrUdang(double mbwUdang){
  if (mbwUdang == 0.01) {
    return 500.00;
  } else if (mbwUdang == 0.02) {
    return 293.00;
  } else if (mbwUdang == 0.03) {
    return 170.37;
  } else if (mbwUdang == 0.04) {
    return 109.09;
  } else if (0.05 <= mbwUdang && mbwUdang <= 0.06) {
    return 81.25;
  } else if (0.07 <= mbwUdang && mbwUdang <= 0.09) {
    return 62.07;
  } else if (0.10 <= mbwUdang && mbwUdang <= 0.12) {
    return 46.96;
  } else if (0.13 <= mbwUdang && mbwUdang <= 0.15) {
    return 39.46;
  } else if (0.16 <= mbwUdang && mbwUdang <= 0.19) {
    return 33.16;
  } else if (0.20 <= mbwUdang && mbwUdang <= 0.24) {
    return 28.09;
  } else if (0.25 <= mbwUdang && mbwUdang <= 0.29) {
    return 24.49;
  } else if (0.30 <= mbwUdang && mbwUdang <= 0.36) {
    return 20.88;
  } else if (0.37 <= mbwUdang && mbwUdang <= 0.44) {
    return 18.18;
  } else if (0.45 <= mbwUdang && mbwUdang <= 0.53) {
    return 16.23;
  } else if (0.54 <= mbwUdang && mbwUdang <= 0.63) {
    return 14.06;
  } else if (0.64 <= mbwUdang && mbwUdang <= 0.74) {
    return 12.70;
  } else if (0.75 <= mbwUdang && mbwUdang <= 0.85) {
    return 11.72;
  } else if (0.86 <= mbwUdang && mbwUdang <= 0.98) {
    return 10.78;
  } else if (0.99 <= mbwUdang && mbwUdang <= 1.13) {
    return 9.89;
  } else if (1.30 <= mbwUdang && mbwUdang <= 1.46) {
    return 9.30;
  } else if (1.47 <= mbwUdang && mbwUdang <= 1.64) {
    return 8.85;
  } else if (1.65 <= mbwUdang && mbwUdang <= 1.82) {
    return 8.46;
  } else if (1.83 <= mbwUdang && mbwUdang <= 2.01) {
    return 8.11;
  } else if (2.02 <= mbwUdang && mbwUdang <= 2.21) {
    return 7.75;
  } else if (2.22 <= mbwUdang && mbwUdang <= 2.42) {
    return 7.37;
  } else if (2.43 <= mbwUdang && mbwUdang <= 2.65) {
    return 7.02;
  } else if (2.66 <= mbwUdang && mbwUdang <= 2.91) {
    return 6.63;
  } else if (2.92 <= mbwUdang && mbwUdang <= 3.20) {
    return 6.19;
  } else if (3.21 <= mbwUdang && mbwUdang <= 3.52) {
    return 5.82;
  } else if (3.53 <= mbwUdang && mbwUdang <= 3.86) {
    return 5.58;
  } else if (3.89 <= mbwUdang && mbwUdang <= 4.22) {
    return 5.46;
  } else if (4.23 <= mbwUdang && mbwUdang <= 4.58) {
    return 5.41;
  } else if (4.59 <= mbwUdang && mbwUdang <= 4.95) {
    return 5.35;
  } else if (4.96 <= mbwUdang && mbwUdang <= 5.32) {
    return 5.30;
  } else if (5.33 <= mbwUdang && mbwUdang <= 5.69) {
    return 5.24;
  } else if (5.70 <= mbwUdang && mbwUdang <= 6.06) {
    return 5.18;
  } else if (6.07 <= mbwUdang && mbwUdang <= 6.43) {
    return 5.11;
  } else if (6.44 <= mbwUdang && mbwUdang <= 6.80) {
    return 5.05;
  } else if (6.81 <= mbwUdang && mbwUdang <= 7.17) {
    return 4.98;
  } else if (7.18 <= mbwUdang && mbwUdang <= 7.53) {
    return 4.92;
  } else if (7.54 <= mbwUdang && mbwUdang <= 7.91) {
    return 4.83;
  } else if (7.92 <= mbwUdang && mbwUdang <= 8.31) {
    return 4.69;
  } else if (8.32 <= mbwUdang && mbwUdang <= 8.70) {
    return 4.53;
  } else if (8.71 <= mbwUdang && mbwUdang <= 9.10) {
    return 4.38;
  } else if (9.11 <= mbwUdang && mbwUdang <= 9.51) {
    return 4.28;
  } else if (9.52 <= mbwUdang && mbwUdang <= 9.90) {
    return 4.23;
  } else if (9.91 <= mbwUdang && mbwUdang <= 10.32) {
    return 4.11;
  } else if (10.33 <= mbwUdang && mbwUdang <= 10.75) {
    return 3.96;
  } else if (10.76 <= mbwUdang && mbwUdang <= 11.21) {
    return 3.87;
  } else if (11.22 <= mbwUdang && mbwUdang <= 11.41) {
    return 3.82;
  } else if (11.42 <= mbwUdang && mbwUdang <= 11.71) {
    return 3.78;
  } else if (11.72 <= mbwUdang && mbwUdang <= 12.61) {
    return 3.51;
  } else if (12.62 <= mbwUdang && mbwUdang <= 13.07) {
    return 3.48;
  } else if (13.08 <= mbwUdang && mbwUdang <= 13.52) {
    return 3.38;
  } else if (13.53 <= mbwUdang && mbwUdang <= 13.98) {
    return 3.28;
  } else if (13.99 <= mbwUdang && mbwUdang <= 14.44) {
    return 3.19;
  } else if (14.45 <= mbwUdang && mbwUdang <= 14.91) {
    return 3.09;
  } else if (14.92 <= mbwUdang && mbwUdang <= 15.58) {
    return 2.99;
  } else if (15.59 <= mbwUdang && mbwUdang <= 16.00) {
    return 2.80;
  } else if (16.01 <= mbwUdang && mbwUdang <= 16.99) {
    return 2.70;
  } else if (17.00 <= mbwUdang && mbwUdang <= 18.00) {
    return 2.50;
  } else if (18.01 <= mbwUdang && mbwUdang <= 20.00) {
    return 2.40;
  } else if (20.01 <= mbwUdang && mbwUdang <= 22.00) {
    return 2.20;
  } else if (22.01 <= mbwUdang && mbwUdang <= 25.37) {
    return 2.10;
  } else {
    return 0.00;
  }
  }

static CollectionReference shrimp =
      FirebaseFirestore.instance.collection('shrimps');

  static  insertDataToFirestore({required CollectionReference database, required Map<String,dynamic> shrimp}){
      return database
        .add(shrimp)
        .then((value) => print("${database} Added"))
        .catchError((error) => print("Failed to add ${database}: $error"));
  }

  static insertDataToRealtimeDatbaase({required DatabaseReference ref, required Shrimp shrimp}){
    ref.child('admin').update(shrimp.toMap()).then((_) {
      print('Data saved successfully.');
    }).catchError((error) {
      print('Failed to save data: $error');
    });
  }

  static updateSensor({required refSensor,required field, required status}){
      // DatabaseReference refSensor = FirebaseDatabase.instance.ref('Sensor');

 refSensor.update({
  '${field}' : status
 }).then((_) {
      print('Data saved successfully.');
    }).catchError((error) {
      print('Failed to save data: $error');
    });
  }

  static void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Silakan Pilih'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
