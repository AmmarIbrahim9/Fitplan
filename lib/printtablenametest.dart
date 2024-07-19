// firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitplanv_1/tableservice.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TableService _tableService = TableService();

  Future<String?> getUserTable() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        print('No user logged in.');
        return null;
      }

      String uid = currentUser.uid;
      print('Fetching user document for UID: $uid');

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        print('User document not found for UID: $uid');
        return null;
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      String? bmiCategory = _calculateBMICategory(userData);
      Map<String, dynamic>? conditionsMap = userData['conditions'] as Map<String, dynamic>?;
      String medicalCondition = _extractMedicalCondition(conditionsMap);
      String? eatingSystem = userData['diet'] as String? ?? '';

      String tableName = _tableService.determineTableName(bmiCategory, medicalCondition, eatingSystem);

      print('Table Name: $tableName');

      return tableName;
    } catch (e, stackTrace) {
      print('Error fetching user data: $e');
      print('StackTrace: $stackTrace');
      return null;
    }
  }

  String _calculateBMICategory(Map<String, dynamic> userData) {
    double height = userData['height']?.toDouble() ?? 0;
    double weight = userData['weight']?.toDouble() ?? 0;
    double bmi = _calculateBMI(weight, height);

    if (bmi < 18.5) {
      return 'underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'normal';
    } else {
      return 'overweight';
    }
  }

  double _calculateBMI(double weight, double height) {
    return weight / ((height / 100) * (height / 100));
  }

  String _extractMedicalCondition(Map<String, dynamic>? conditionsMap) {
    if (conditionsMap == null || conditionsMap.isEmpty) {
      return 'None';
    }

    if (conditionsMap.containsKey('medicalCondition')) {
      return conditionsMap['medicalCondition'] as String;
    } else {
      return 'None';
    }
  }
}
