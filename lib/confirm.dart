import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<Confirm> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPressed = !_isPressed; // Toggle the button's pressed state
        });
      },
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) || _isPressed) {
              return Colors.black; // Change color to black when pressed or when previously clicked
            }
            return Colors.transparent; // Default color
          }),
          elevation: MaterialStateProperty.all<double>(0),
          side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.white)), // White edges
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), // Rounded corners
        ),
        onPressed: () {
          // Button action here
        },
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Confirm',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Bold text
              color: Colors.white,
              fontSize: 29, // White text color
            ),
          ),
        ),
      ),
    );
  }
}
