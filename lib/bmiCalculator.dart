import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculator());
}

class BMICalculator extends StatelessWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BMI Calculator'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownForm(),
        ),
      ),
    );
  }
}

class DropdownForm extends StatefulWidget {
  const DropdownForm({Key? key}) : super(key: key);

  @override
  _DropdownFormState createState() => _DropdownFormState();
}

class _DropdownFormState extends State<DropdownForm> {
  int? _selectedHeight;
  int? _selectedWeight;
  double? _bmi;
  String? _bmiResult;

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
          _buildDropdown(
              'Select Height',
              List<int>.generate(66, (i) => 145 + i)
                  .map((e) => '$e cm')
                  .toList(), (String? value) {
            setState(() {
              _selectedHeight = int.tryParse(value!.split(' ')[0]);
            });
          }),
          const SizedBox(height: 20),
          _buildDropdown(
              'Select Weight',
              List<int>.generate(111, (i) => 40 + i)
                  .map((e) => '$e kg')
                  .toList(), (String? value) {
            setState(() {
              _selectedWeight = int.tryParse(value!.split(' ')[0]);
            });
          }),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: _calculateBMI,
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          if (_bmiResult != null) _buildBMIResult(),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String hint, List<String> items, void Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String?>(
        isExpanded: true,
        underline: const SizedBox(),
        value: hint == 'Select Height'
            ? _selectedHeight != null
                ? '$_selectedHeight cm'
                : null
            : _selectedWeight != null
                ? '$_selectedWeight kg'
                : null,
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

  void _calculateBMI() {
    if (_selectedHeight == null || _selectedWeight == null) {
      _showErrorDialog(
          'Please select your height and weight before proceeding.');
      return;
    }

    if (_selectedHeight != null && _selectedWeight != null) {
      double heightInMeters = _selectedHeight! / 100;
      _bmi = _selectedWeight! / (heightInMeters * heightInMeters);
      String category;
      if (_bmi! < 18.5) {
        category = "Underweight";
      } else if (_bmi! >= 18.5 && _bmi! < 24.9) {
        category = "Normal weight";
      } else if (_bmi! >= 25 && _bmi! < 29.9) {
        category = "Overweight";
      } else {
        category = "Obesity";
      }
      setState(() {
        _bmiResult = 'Your BMI is ${_bmi!.toStringAsFixed(2)}: $category';
      });
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

  Widget _buildBMIResult() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BMI Result:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              _bmiResult!,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: _bmi! / 40,
              backgroundColor: Colors.teal[100],
              color: Colors.teal,
              minHeight: 10,
            ),
          ],
        ),
      ),
    );
  }
}
