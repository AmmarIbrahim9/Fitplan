import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String? email;
  final String? gender;
  final int? height;
  final int? weight;
  final String? diet;
  final Map<String, bool> conditions;
  final double? bmi;
  final DateTime? createdAt;

  UserData({
    required this.uid,
    this.email,
    this.gender,
    this.height,
    this.weight,
    this.diet,
    required this.conditions,
    this.bmi,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'gender': gender,
      'height': height,
      'weight': weight,
      'diet': diet,
      'conditions': conditions,
      'bmi': bmi,
      'createdAt': createdAt,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'],
      email: map['email'],
      gender: map['gender'],
      height: map['height'],
      weight: map['weight'],
      diet: map['diet'],
      conditions: Map<String, bool>.from(map['conditions']),
      bmi: map['bmi'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
