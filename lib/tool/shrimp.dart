import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Shrimp {
  String? id;
  double shrimpLength;
  int age;
  double mbw;
  double feedRatio;
  double pakanUdan;
  String image;
  String dateTime;
  Shrimp({
    required this.shrimpLength,
    required this.age,
    required this.mbw,
    required this.feedRatio,
    required this.pakanUdan,
    required this.image,
    this.id,
    required this.dateTime
  });
  


  Shrimp copyWith({
    double? shrimpLength,
    int? age,
    double? mbw,
    double? feedRatio,
    double? pakanUdan,
    String? image,
  }) {
    return Shrimp(
      shrimpLength: shrimpLength ?? this.shrimpLength,
      age: age ?? this.age,
      mbw: mbw ?? this.mbw,
      feedRatio: feedRatio ?? this.feedRatio,
      pakanUdan: pakanUdan ?? this.pakanUdan,
      image: image ?? this.image, dateTime: dateTime ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shrimpLength': shrimpLength,
      'age': age,
      'mbw': mbw,
      'feedRatio': feedRatio,
      'pakanUdan': pakanUdan,
      'image': image,
      'dateTime': dateTime,
    };
  }

   factory Shrimp.fromSnapshot(DocumentSnapshot map) {
    return Shrimp(
      id: map.id,
      shrimpLength: map['shrimpLength'] as double,
      age: map['age'] as int,
      mbw: map['mbw'] as double,
      feedRatio: map['feedRatio'] as double,
      pakanUdan: map['pakanUdan'] as double,
      image: map['image'] as String, dateTime: map["dateTime"] as String,
    );
  }
  factory Shrimp.fromMap(Map<String, dynamic> map) {
    return Shrimp(
      shrimpLength: map['shrimpLength'] as double,
      age: map['age'] as int,
      mbw: map['mbw'] as double,
      feedRatio: map['feedRatio'] as double,
      pakanUdan: map['pakanUdan'] as double,
      image: map['image'] as String, dateTime: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Shrimp.fromJson(String source) => Shrimp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Shrimp(shrimpLength: $shrimpLength, age: $age, mbw: $mbw, feedRatio: $feedRatio, pakanUdan: $pakanUdan, image: $image)';
  }

  @override
  bool operator ==(covariant Shrimp other) {
    if (identical(this, other)) return true;
  
    return 
      other.shrimpLength == shrimpLength &&
      other.age == age &&
      other.mbw == mbw &&
      other.feedRatio == feedRatio &&
      other.pakanUdan == pakanUdan &&
      other.image == image;
  }

  @override
  int get hashCode {
    return shrimpLength.hashCode ^
      age.hashCode ^
      mbw.hashCode ^
      feedRatio.hashCode ^
      pakanUdan.hashCode ^
      image.hashCode;
  }
}
