import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitplanv_1/calender.dart';
import 'package:fitplanv_1/homepage.dart';
import 'package:fitplanv_1/login.dart';
import 'package:fitplanv_1/navbar.dart';
import 'package:fitplanv_1/printtablenametest.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const UserInput1());
}

class UserInput1 extends StatelessWidget {
  const UserInput1({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkUserDataExists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            bool userDataExists = snapshot.data ?? false;
            if (userDataExists) {
              return Scaffold(
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.teal.shade200, Colors.teal],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Form already filled, proceeding to homepage...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => Navbar()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                  ),
                                  child: const Text(
                                    'Go to Homepage',
                                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              );
            } else {
              return MaterialApp(
                theme: ThemeData(
                  primarySwatch: Colors.teal,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: Scaffold(
                  appBar: AppBar(
                    title: const Text('User Input'),
                    centerTitle: true,
                  ),
                  body: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: DropdownForm(),
                  ),
                ),
              );
            }
          }
        }
      },
    );
  }

  Future<bool> _checkUserDataExists() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userData = await usersCollection.doc(currentUser.uid).get();

      // Check if all required fields exist in the Firestore document
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
}

class DropdownForm extends StatefulWidget {
  const DropdownForm({super.key});

  @override
  _DropdownFormState createState() => _DropdownFormState();
}

class _DropdownFormState extends State<DropdownForm> {
  String? _selectedGender;
  int? _selectedHeight;
  int? _selectedWeight;
  String? _selectedDiet;
  final Map<String, bool> _selectedConditions = {
    'Hypertension': false,
    'Hypotension': false,
    'Diabetes': false,
    'None': false,
  };
  double? _bmi;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            'Select Health Conditions:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          ..._selectedConditions.keys.map((condition) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(condition),
                    Checkbox(
                      value: _selectedConditions[condition],
                      onChanged: (bool? value) {
                        setState(() {
                          if (condition == 'None' && value == true) {
                            for (var key in _selectedConditions.keys) {
                              _selectedConditions[key] = key == 'None';
                            }
                          } else {
                            _selectedConditions[condition] = value!;
                            _selectedConditions['None'] = false;
                          }
                        });
                      },
                      activeColor: Colors.teal,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
              ],
            );
          }),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
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
    );
  }

  Widget _buildDropdown(String hint, List<String> items, void Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
    // Check if user data already exists
    if (await _checkUserDataExists()) {
      // User data already exists, skip saving and proceed to next screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navbar()));
      return;
    }

    // Validate form inputs
    if (_selectedGender == null || _selectedHeight == null || _selectedWeight == null || _selectedDiet == null) {
      _showErrorDialog('Please select your gender, height, weight, and diet before proceeding.');
      return;
    }

    if (!_selectedConditions.containsValue(true) && !_selectedConditions['None']!) {
      _showErrorDialog('Please select at least one health condition or choose "None" before proceeding.');
      return;
    }

    _calculateBMI();

    // Save data to Firestore
    _saveUserDataToFirestore();
  }

  Future<bool> _checkUserDataExists() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userData = await usersCollection.doc(currentUser.uid).get();

      // Check if all required fields exist in the Firestore document
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

  void _calculateBMI() {
    if (_selectedHeight != null && _selectedWeight != null) {
      double heightInMeters = _selectedHeight! / 100;
      _bmi = _selectedWeight! / (heightInMeters * heightInMeters);
      print('Your BMI is ${_bmi!.toStringAsFixed(2)}');
    }
  }

  void _saveUserDataToFirestore() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final usersCollection = FirebaseFirestore.instance.collection('users');

      Map<String, dynamic> userData = {
        'uid': currentUser.uid,
        'email': currentUser.email,
        'gender': _selectedGender,
        'height': _selectedHeight,
        'weight': _selectedWeight,
        'diet': _selectedDiet,
        'conditions': _selectedConditions,
        'bmi': _bmi,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await usersCollection.doc(currentUser.uid).set(userData);
    } catch (e) {
      print('Error saving user data: $e');
      _showErrorDialog('Failed to save user data. Please try again later.');
    }

    // Handle navigation or error display after saving user data
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navbar()));
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
}
