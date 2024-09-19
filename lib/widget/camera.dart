import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pakan_udang/main.dart';
import 'package:pakan_udang/tool/shrimp.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img_converter;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pakan_udang/tool/helper.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraCard extends StatefulWidget {
  @override
  State<CameraCard> createState() => _CameraCardState();
}

class _CameraCardState extends State<CameraCard> {
  double resultPakanUdang = 0;
  double resultpanjang_udang_cm = 0;
  int resultumur_udang = 0;
  double resultmbwUdang = 0;
  double resultfrUdang = 0;
  double faktor_konversi = 25.076256;
  double populasi = 55.000;
  File? _imgFile;
  String? base64String;
  String umur_udang_melebihi = "Lebih dari 18 minggu";

  final storageRef = FirebaseStorage.instance.ref();
  DatabaseReference ref = FirebaseDatabase.instance.reference().child('Shrimp');
  final firestoreRef = FirebaseFirestore.instance.collection('shrimps');


  Map<String, dynamic>? userData;
  late Future<QuerySnapshot> querySnapshot;

  fetchData() async {
    setState(() {
      querySnapshot = Helpers.shrimp.get();
    });
  }

  Future<String> uploadImage(_image) async {
    if (_image == null) return "";
    print("masuk");
    final imagesRef = storageRef.child("images");
    final mountainsRef =
        imagesRef.child("${DateTime.now().millisecondsSinceEpoch}.jpg");
    File file = _image;

    try {
      UploadTask uploadTask = mountainsRef.putFile(file);
      var storageTaskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      var logger = Logger();
      logger.e(downloadUrl);

      return downloadUrl;
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return "";
    }
  }

  void _showBottomSheet(BuildContext context) {
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
                Text('Pilih Foto'),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();

                    final ImagePicker picker = ImagePicker();
                    final img = await picker.pickImage(
                      source: ImageSource
                          .camera, 
                    );
                    pointsResult(img!, context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera),
                      SizedBox(
                        width: 12.0,
                      ),
                      Expanded(child: Text("Camera"))
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    final ImagePicker picker = ImagePicker();
                    final img = await picker.pickImage(
                      source: ImageSource
                          .gallery, 
                    );
                    pointsResult(img!, context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      SizedBox(
                        width: 12.0,
                      ),
                      Expanded(child: Text("Galeri"))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  pointsResult(XFile img, context) async {
    if (img == null) return;


    
    //convert quality
    var fileFromImage = File(img.path);
    var basename = path.basenameWithoutExtension(fileFromImage.path);
    var pathString =
        fileFromImage.path.split(path.basename(fileFromImage.path))[0];
    var pathStringWithExtension = "$pathString${basename}_image.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      img.path,
      pathStringWithExtension,
      quality: 80,
    );


    final image = img_converter.decodeImage(await result!.readAsBytes());
    final resizedImage = img_converter.copyResize(image!, width: 640, height: 640);
    
   img_converter.Image adjustedImage = img_converter.adjustColor(resizedImage, hue: 10, saturation: 1);

    // Encode the edited image to bytes
    Uint8List editedImageData = Uint8List.fromList(img_converter.encodeJpg(adjustedImage));
    String paths = result.path;

    File fileData = File(paths);

  // Write the data to the file
  await fileData.writeAsBytes(editedImageData);

    setState(() {
      _imgFile = fileData;
    });
    //convert to base64String
    List<int> imageBytes = fileData.readAsBytesSync();
    base64String = base64Encode(imageBytes);
    debugPrint(base64String);

    var response = await http.post(
        Uri.parse(
            "https://detect.roboflow.com/shrimp_segmentation/3?api_key=pGAKPPiB9hqZUAUvTgPt"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: base64String);

    if (response.statusCode == 413) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Size Image Terlalu besar")));
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Size Image Terlalu besar")));
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    var logger = Logger(
      filter: null,
      printer: PrettyPrinter(),
      output: null,
    );
    logger.e(responseData);

    final predictions = responseData["predictions"] as List<dynamic>;
    for (var i = 0; i < predictions.length; i++) {
      final points = predictions[i]["points"] as List<dynamic>;

      double panjang_total_pixel = 0;

      for (var j = 0; j < (points.length - 1); j++) {
        double panjang_segmen_pixel = Helpers.lin(points[j], points[j + 1]);
        panjang_total_pixel += panjang_segmen_pixel;
      }

      var panjang_udang_cm = (panjang_total_pixel / faktor_konversi) / 2;
      print(
          "Panjang Objek ${predictions[0]["class"]} : ${panjang_udang_cm} cm");
      int umur_udang = 0;

      umur_udang = Helpers.getUmurUdang(panjang_udang_cm);

      if (umur_udang != 0) {
        print("Umur udang: ${umur_udang.toString()} minggu");
      } else {
        print("Umur udang: ${umur_udang_melebihi} minggu");
      }

      double mbwUdang = 0;
      String mbwTidakTersedia = "Informasi dosis tidak tersedia";
      if (umur_udang != null) {
        mbwUdang = Helpers.getMbwUdang(umur_udang);
      }

      if (umur_udang != 0) {
        print("MBW udang: $mbwUdang");
      } else {
        print("MBW udang: ${mbwTidakTersedia.toString()}");
      }

      double? frUdang;
      String frUdangTidakTersedia = "Informasi FR tidak tersedia";

      frUdang = Helpers.getFrUdang(mbwUdang);
      if (frUdang == 0.0) {
        ScaffoldMessenger.of(globalNavigatorKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(frUdangTidakTersedia)));
      }

      print("Feed Ratio (FR): $frUdang%");

      //Banyak biomasa
      double biomassa = mbwUdang! * populasi;
      double pakanUdang = (frUdang! * biomassa) / 1000;
      ScaffoldMessenger.of(globalNavigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text("Informasi Pakan Udang Tidak tersedia")));

      String imagePath = await uploadImage(File(result!.path));

      setState(() {
        resultPakanUdang = pakanUdang;
        resultpanjang_udang_cm = panjang_udang_cm;
        resultumur_udang = umur_udang;
        resultmbwUdang = mbwUdang;
        resultfrUdang = frUdang!;
      });
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('dd MMMM yyyy hh:mm a').format(now);

      Helpers.insertDataToFirestore(
          database: Helpers.shrimp,
          shrimp: Shrimp(
                  age: umur_udang,
                  feedRatio: frUdang,
                  image: imagePath,
                  mbw: mbwUdang,
                  pakanUdan: pakanUdang,
                  shrimpLength: panjang_udang_cm,
                  dateTime: formattedDateTime)
              .toMap());
      Helpers.insertDataToRealtimeDatbaase(ref: ref, shrimp: Shrimp(shrimpLength: panjang_udang_cm, age: umur_udang, mbw: mbwUdang, feedRatio: frUdang, pakanUdan: pakanUdang, image: imagePath, dateTime: formattedDateTime));
      print("Pakan Udang: $pakanUdang kg");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Foto Terakhir:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
                  StreamBuilder(
              stream: Helpers.shrimp.orderBy('dateTime', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Or any other loading indicator
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      Shrimp shrimp = Shrimp.fromSnapshot(doc);

                      // Pengaturan data tanggal dan waktu (placeholder)
                      String date = "12 April 2024";
                      String time = "10:00 AM";

                      List<String> dateTimeParts = shrimp.dateTime.split(" ");
                      String dateParts = dateTimeParts.sublist(0, 3).join(" ");
                      String timeParts = dateTimeParts.sublist(3).join(" ");
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          children: [
                            // Widget untuk menampilkan data tanggal dan waktu
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                   dateParts,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    timeParts,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10), // Spacer antara data dan foto
                            // Widget untuk menampilkan foto
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Shrimp Detail'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "Panjang Objek Shrimp : ${shrimp.shrimpLength}"),
                                              Text(
                                                  "Umur Udang : ${shrimp.age} minggu"),
                                              Text(
                                                  "MBW Udang Shrimp : ${shrimp.mbw}"),
                                              Text(
                                                  "Feed Ratio (FR) : ${shrimp.feedRatio}%"),
                                              Text(
                                                  "Pakan Udang : ${shrimp.pakanUdan} kg"),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: (shrimp.image != '')
                                      ? Image.network(
                                          shrimp.image,
                                          fit: BoxFit.contain,
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.image_outlined,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            IconButton(icon: Icon(Icons.delete), color: Colors.red, onPressed: (){
                                    showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                        title: Text("Apakah Anda yakin akan menghapus data ini?"),
                                        actions: [
                                          ElevatedButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: Text("Batal")),
                                          ElevatedButton(style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white
                                          ),onPressed: () async{
                                            await firestoreRef.doc(shrimp.id).delete().then((value) {
                                              Navigator.pop(context);
          ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sukses Menghapus Data")));
                                            });
                                          }, child: Text("Hapus")),
                                        ],
                                      );
                                    },);
                            },)
                          ],
                        ),
                      );
                    },
                  ),
          );
              }),
          Divider(
            height: 2.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          (_imgFile != null)
              ? Stack(alignment: Alignment.center, children: [
                  Image.file(
                    _imgFile!,
                    height: 200,
                    width: 200,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    color: Colors.transparent,
                    child: (resultpanjang_udang_cm == 0)
                        ? Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator())
                        : SizedBox.shrink(),
                  )
                ])
              : SizedBox.shrink(),
          (resultpanjang_udang_cm != 0)
              ? Column(
                  children: [
                    Text("Panjang Objek Shrimp : ${resultpanjang_udang_cm}"),
                    Text("Umur Udang : ${resultumur_udang} minggu"),
                    Text("MBW Udang Shrimp : ${resultmbwUdang}"),
                    Text("Feed Ratio (FR) : ${resultfrUdang}%"),
                    Text("Pakan Udang : ${resultPakanUdang} kg"),
                  ],
                )
              : SizedBox.shrink(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  resultPakanUdang = 0.0;
                  resultpanjang_udang_cm = 0.0;
                  resultumur_udang = 0;
                  resultmbwUdang = 0;
                  resultfrUdang = 0.0;
                  _imgFile = null;
                });

                bool permissionStatus;
                final deviceInfo = await DeviceInfoPlugin().androidInfo;

                if (deviceInfo.version.sdkInt > 32) {
                  permissionStatus =
                      await Permission.photos.request().isGranted;
                } else {
                  permissionStatus =
                      await Permission.storage.request().isGranted;
                }

                if (permissionStatus) {
                  // pointsResult();
                  // Helpers.showBottomSheet(context);
                  _showBottomSheet(context);
                }
                // Tambahkan fungsi untuk mengambil foto
              },
              icon: Icon(Icons.camera_alt_sharp),
              label: Text('AMBIL FOTO'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
