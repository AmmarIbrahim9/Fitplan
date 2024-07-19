import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
      FirebaseFirestore.instance.collection('profiles').doc(user.uid);
      final doc = await docRef.get();
      if (doc.exists) {
        setState(() {
          _currentUsername = doc['username'];
          _usernameController.text = _currentUsername ?? '';
        });
      } else {
        // If the document doesn't exist, create it with the username field
        await docRef.set({
          'username': '', // You can set a default username here if needed
        });
        setState(() {
          _currentUsername = '';
        });
      }
    }
  }

  Future<void> _saveUsername() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final newUsername = _usernameController.text.trim();
      if (newUsername.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(user.uid)
            .set({'username': newUsername}, SetOptions(merge: true));
        setState(() {
          _currentUsername = newUsername;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_currentUsername != null && _currentUsername!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Current Username: $_currentUsername',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Enter new username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveUsername,
              child: Text('Save Username' , style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                padding: EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
