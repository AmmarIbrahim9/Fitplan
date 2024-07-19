import 'package:flutter/material.dart';



class CheckboxButton extends StatefulWidget {
  @override
  _CheckboxButtonState createState() => _CheckboxButtonState();
}

class _CheckboxButtonState extends State<CheckboxButton> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Checkbox(
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
            },
          ),
          TextButton(
            onPressed: () {
              // Your onPressed logic
            },
            child: const Text(
              'I agree to terms and conditions ',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Color(0xff4c505b),
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
