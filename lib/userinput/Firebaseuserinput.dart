import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<bool> checkUserDataExists() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userData = await usersCollection.doc(currentUser.uid).get();

      if (userData.exists) {
        final data = userData.data();
        if (data == null) {
          return false;
        }
        return data.containsKey('gender') &&
            data.containsKey('height') &&
            data.containsKey('weight') &&
            data.containsKey('diet') &&
            data.containsKey('conditions') &&
            data.containsKey('bmi');
      }
      return false;
    } catch (e) {
      print('Error checking user data: $e');
      return false;
    }
  }

  static void saveUserDataToFirestore(String? gender, int? height, int? weight, String? diet, Map<String, bool> conditions, double? bmi) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final usersCollection = FirebaseFirestore.instance.collection('users');

      Map<String, dynamic> userData = {
        'uid': currentUser.uid,
        'email': currentUser.email,
        'gender': gender,
        'height': height,
        'weight': weight,
        'diet': diet,
        'conditions': conditions,
        'bmi': bmi,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await usersCollection.doc(currentUser.uid).set(userData);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
