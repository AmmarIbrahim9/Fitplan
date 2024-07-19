import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../navbar.dart'; // Replace with your actual imports

class DropdownForm extends StatefulWidget {
  const DropdownForm({Key? key}) : super(key: key);

  @override
  _DropdownFormState createState() => _DropdownFormState();
}

class _DropdownFormState extends State<DropdownForm> {
  String? _selectedGender;
  int? _selectedHeight;
  int? _selectedWeight;
  String? _selectedDiet;
  String? _selectedCondition;
  double? _bmi;

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users'); // Replace 'users' with your Firestore collection name
  late User _currentUser; // Firebase User object

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!; // Get current user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Input Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Please fill out the information below:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              _buildDropdown('Select Gender', <String>['Male', 'Female'], (String? value) {
                setState(() {
                  _selectedGender = value;
                });
              }),
              const SizedBox(height: 20),
              _buildDropdown('Select Height', List<int>.generate(66, (i) => 145 + i).map((e) => '$e cm').toList(), (String? value) {
                setState(() {
                  _selectedHeight = int.tryParse(value!.split(' ')[0]);
                });
              }),
              const SizedBox(height: 20),
              _buildDropdown('Select Weight', List<int>.generate(111, (i) => 40 + i).map((e) => '$e kg').toList(), (String? value) {
                setState(() {
                  _selectedWeight = int.tryParse(value!.split(' ')[0]);
                });
              }),
              const SizedBox(height: 20),
              _buildDropdown('Select Diet', <String>['Vegetarian', 'Mediterranean', 'DASH'], (String? value) {
                setState(() {
                  _selectedDiet = value;
                });
              }),
              const SizedBox(height: 20),
              const Text(
                'Select Health Condition:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              ...['Hypertension', 'Hypotension', 'Diabetes', 'None'].map((condition) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(condition)),
                        Radio<String>(
                          value: condition,
                          groupValue: _selectedCondition,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedCondition = value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                  ],
                );
              }).toList(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _performNextAction,
                  child: const Text('Next', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, void Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black12.withOpacity(0.2), // Transparent white background
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String?>(
        isExpanded: true,
        underline: const SizedBox(),
        value: hint == 'Select Gender'
            ? _selectedGender
            : hint == 'Select Height'
            ? _selectedHeight != null
            ? '$_selectedHeight cm'
            : null
            : hint == 'Select Weight'
            ? _selectedWeight != null
            ? '$_selectedWeight kg'
            : null
            : _selectedDiet,
        hint: Text(hint),
        items: items.map<DropdownMenuItem<String?>>((String value) {
          return DropdownMenuItem<String?>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _performNextAction() async {
    if (_selectedGender == null ||
        _selectedHeight == null ||
        _selectedWeight == null ||
        _selectedDiet == null) {
      _showErrorDialog('Please select your gender, height, weight, and diet before proceeding.');
      return;
    }

    if (_selectedCondition == null) {
      _showErrorDialog('Please select one health condition before proceeding.');
      return;
    }

    _calculateBMI();
    try {
      await saveUserDataToFirestore(
        _currentUser.uid, // Use the current user's UID as the document ID
        _selectedGender!,
        _selectedHeight!,
        _selectedWeight!,
        _selectedDiet!,
        {_selectedCondition!: true},
        _bmi,
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navbar())); // Replace Navbar() with your actual navigation destination
    } catch (e) {
      print('Error saving user data: $e');
      _showErrorDialog('Failed to update user data. Please try again later.');
    }
  }

  void _calculateBMI() {
    if (_selectedHeight != null && _selectedWeight != null) {
      double heightInMeters = _selectedHeight! / 100;
      _bmi = _selectedWeight! / (heightInMeters * heightInMeters);
      print('Your BMI is ${_bmi!.toStringAsFixed(2)}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveUserDataToFirestore(String userId, String gender, int height, int weight, String diet, Map<String, bool> conditions, double? bmi) async {
    try {
      await usersCollection.doc(userId).set({
        'gender': gender,
        'height': height,
        'weight': weight,
        'diet': diet,
        'conditions': conditions,
        'bmi': bmi,
        'timestamp': FieldValue.serverTimestamp(), // Optional: Add server timestamp
      }, SetOptions(merge: true)); // Merge set options to update existing fields without overwriting
    } catch (e) {
      print('Error saving user data: $e');
      throw e;
    }
  }
}
