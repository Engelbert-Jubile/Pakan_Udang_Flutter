// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:pakan_udang/tool/helper.dart';

class PakanCard extends StatefulWidget {


  
  @override
  _PakanCardState createState() => _PakanCardState();
}

class _PakanCardState extends State<PakanCard> {
  
  TimeOfDay _selectedTime = TimeOfDay(hour: 23,minute: 00);


  Future<void> _selectTime(BuildContext context,index,  initial) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initial,
        initialEntryMode: TimePickerEntryMode.dialOnly);

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        initial = pickedTime;
        print("here");
        print(initial.format(context));
        var split = initial.format(context).split(':');
        print(split[0]);
        Helpers.updateSensor(refSensor: refSensor, field: 'jam${index+1}', status: split[0]);
        Helpers.updateSensor(refSensor: refSensor, field: 'menit${index+1}', status: split[1]);
      });
    }
  }
  

    
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  DatabaseReference refSensor = FirebaseDatabase.instance.ref().child("Sensor");
  List<TimeOfDay> listOfTimeDay = [
      TimeOfDay(hour: 05,minute: 00),
 TimeOfDay(hour: 12,minute: 00),
TimeOfDay(hour: 16,minute: 00),
 TimeOfDay(hour: 19,minute: 00),
TimeOfDay(hour: 23,minute: 00)
  ];
  @override
  Widget build(BuildContext context) {
    return  Padding(  
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                              stream: refSensor.onValue,
                              builder: (context, snap) {
                               if (snap.hasData && !snap.hasError && snap.data?.snapshot.value != null) {
                              
                        Map data = snap.data?.snapshot.value as Map<dynamic, dynamic>;
                        List item = [];
                              
                      print(data);
                      return ListView.builder(itemBuilder: (context, index) {
                        // data["jam${index+1}Status"];
                                              bool isPakanOn = data["jam${index+1}Status"];
                      String dataTime = TimeOfDay(hour: int.parse(data["jam${index+1}"]), minute: int.parse(data["menit${index+1}"])).format(context);
                      TimeOfDay initialDate = TimeOfDay(hour: int.parse(data["jam${index+1}"]), minute: int.parse(data["menit${index+1}"]));
                  return GestureDetector(
                    onTap: () => _selectTime(context,index, initialDate),
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      color:  data["jam${index+1}Status"]
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
                'Beri Pakan Jam ${dataTime}',
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
                    value:  isPakanOn,
                    onChanged: (value) {
                      setState(() {
                        isPakanOn = value;
                        Helpers.updateSensor(refSensor: refSensor,field:  'jam${index+1}Status', status: value);
                      });
                    },
                  ),
                ],
              ),
                              ],
                        ),
                      ),
                    ),
                  );
                  }, itemCount: 5);
                       
              } else{
                 return Center(
                        child: CircularProgressIndicator(),
                      );
              }
                              })
            
                          
    );
  }
}
