import 'package:fitplanv_1/signup.dart';
import 'package:flutter/material.dart';

class TermsAndServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive sizes
    final titleFontSize = screenWidth * 0.05; // 5% of screen width
    final contentFontSize = screenWidth * 0.03; // 3% of screen width
    final paddingSize = screenWidth * 0.05; // 5% of screen width for padding

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Hero(
          tag: 'closeButton',
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(paddingSize), // Use calculated padding
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.02), // Use calculated spacing
            Text(
              'Terms and Services',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto', // Use a modern font
                color: Colors.black87, // Slightly darker color for better readability
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Use calculated spacing
            Section(
              title: '1. User Conduct',
              content:
              '•You are responsible for all activities that occur in connection with your account and the App. You agree not to engage in any of the following prohibited activities:\n\n•Using Google/Facebook login implies acceptance of our terms.\n\n•Post or transmit any material that promotes bigotry, racism, hatred, or harm against any group or individual.\n\n•Post or transmit any material that contains viruses, worms, Trojan horses, or any other harmful or destructive material.',
              fontSize: contentFontSize,
            ),
            Section(
              title: '2. Health and Wellness Services',
              content:
              '•The FitPlan mobile application offers tailored dietary plans and health-related guidance. The content provided within the app is designed to serve as a guide and is not intended to substitute for professional medical consultation. It is recommended that users seek advice from a healthcare professional before implementing any dietary changes or health-related modifications based on the guidance offered by the app.',
              fontSize: contentFontSize,
            ),
            Section(
              title: '3. Location sharing consent',
              content:
              '•The user agrees to share his or her location information when using the application.',
              fontSize: contentFontSize,
            ),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String content;
  final double fontSize;

  const Section({required this.title, required this.content, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto', // Use a modern font
            color: Colors.black87, // Slightly darker color for better readability
          ),
        ),
        const SizedBox(height: 10), // Adjust spacing as needed
        Text(
          content,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto', // Use a modern font
            color: Colors.black54, // Use a lighter color for content text
          ),
        ),
        const Divider(color: Colors.grey), // Add a divider between sections
        const SizedBox(height: 20), // Adjust spacing as needed
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Signup(),
  ));
}


