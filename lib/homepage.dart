import 'dart:math';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/mysql.dart'; // Import Firestore

class FitPlanHomePage extends StatefulWidget {
  @override
  _FitPlanHomePageState createState() => _FitPlanHomePageState();
}

class _FitPlanHomePageState extends State<FitPlanHomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late ConfettiController _confettiController;
  bool _isGoalOpen = false;
  ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);
  int totalMeals = 3;
  List<bool> mealCompletion = [false, false, false];
  List<Map<String, dynamic>> _meals = [];
  double currentWeight = 0.0; // Store current weight
  double goalWeight = 0.0; // Store goal weight
  double height = 0.0;
  double bmi = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _confettiController = ConfettiController(duration: Duration(seconds: 3));

    // Fetch user data from Firestore
    _fetchUserData();
    _fetchMealsForToday();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    progressNotifier.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      // Get current user from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is signed in, fetch user document from Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Use user's UID as document ID
            .get();

        // Check if the document exists
        if (userSnapshot.exists) {
          // Fetch currentWeight, BMI, and height from the document, explicitly cast to double
          double currentWeight = (userSnapshot['weight'] ?? 0).toDouble();
          double bmi = (userSnapshot['bmi'] ?? 0).toDouble();
          double heightInCentimeters = (userSnapshot['height'] ?? 0).toDouble();

          // Log the fetched values
          print('Fetched values - Current Weight: $currentWeight, BMI: $bmi, Height: $heightInCentimeters');

          // Calculate goalWeight based on BMI and height
          double goalWeight = calculateGoalWeight(bmi, heightInCentimeters);

          // Log the calculated goal weight
          print('Calculated Goal Weight: $goalWeight');

          // Update state with fetched data
          setState(() {
            this.currentWeight = currentWeight;
            this.height = heightInCentimeters; // Assuming you want to store height in centimeters
            this.goalWeight = goalWeight;
            this.bmi = bmi; // Store the BMI value for display or further use
          });
        } else {
          // Handle if the document does not exist
          print('User document does not exist');
        }
      } else {
        // No user is signed in, handle accordingly
        print('No user signed in');
      }
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print('Error fetching user data: $e');
    }
  }

  double calculateGoalWeight(double bmi, double height) {
    // Convert height from centimeters to meters
    double heightInMeters = height / 100;

    // Use a "perfect" BMI value of 22 if the BMI is not in the normal range
    if (bmi < 18.5 || bmi > 24.9) {
      bmi = 22.0;
      print('Using perfect BMI of 22 for goal weight calculation');
    }

    // Calculate the goal weight using the BMI formula
    double goalWeight = bmi * pow(heightInMeters, 2);

    // Round the goal weight to two decimal places for clarity
    return double.parse(goalWeight.toStringAsFixed(2));
  }

  Future<void> _fetchMealsForToday() async {
    MySQLService mySQLService = MySQLService();
    await mySQLService.connect();
    List<Map<String, dynamic>> meals =
    await mySQLService.fetchDietPlansForCurrentDay();
    await mySQLService.close();

    setState(() {
      _meals = meals;
    });
  }

  void updateProgress(int mealIndex, bool isCompleted) {
    setState(() {
      mealCompletion[mealIndex] = isCompleted;

      int completedMealsCount =
          mealCompletion.where((completed) => completed).length;

      progressNotifier.value = completedMealsCount / totalMeals;

      if (progressNotifier.value == 1.0) {
        _confettiController.play();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FitPlan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildBox(
                          child: _buildWeightContainer(
                            title: 'Current',
                            value: '$currentWeight KG',
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildBox(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isGoalOpen = !_isGoalOpen;
                                if (_isGoalOpen) {
                                  _animationController.forward();
                                } else {
                                  _animationController.reverse();
                                }
                              });
                            },
                            child: _buildGoalContainer(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          ValueListenableBuilder<double>(
                            valueListenable: progressNotifier,
                            builder: (context, value, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Today's Progress",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    value: value,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      '${(value * 100).round()}%',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Today's Plan",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: _meals.isEmpty
                                ? Center(child: CircularProgressIndicator())
                                : ListView.builder(
                              itemCount: totalMeals,
                              itemBuilder: (context, index) {
                                String mealName;
                                String mealTime;
                                String mealDetails;

                                switch (index) {
                                  case 0:
                                    mealName = 'Breakfast';
                                    mealTime = '8:00 AM';
                                    mealDetails = _meals.isNotEmpty
                                        ? _meals[0]['breakfast']
                                        : 'No details available';
                                    break;
                                  case 1:
                                    mealName = 'Lunch';
                                    mealTime = '1:00 PM';
                                    mealDetails = _meals.isNotEmpty
                                        ? _meals[0]['lunch']
                                        : 'No details available';
                                    break;
                                  case 2:
                                    mealName = 'Dinner';
                                    mealTime = '6:30 PM';
                                    mealDetails = _meals.isNotEmpty
                                        ? _meals[0]['dinner']
                                        : 'No details available';
                                    break;
                                  default:
                                    mealName = 'Meal';
                                    mealTime = 'Time';
                                    mealDetails = 'No details available';
                                    break;
                                }

                                return _buildMealPlanItem(
                                  mealName,
                                  mealTime,
                                  mealIndex: index,
                                  mealDetails: mealDetails,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildWeightContainer({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isGoalOpen = !_isGoalOpen;
                if (_isGoalOpen) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Goal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: _animationController,
                  size: 40,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          if (_isGoalOpen) ...[
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$goalWeight KG', // Display goal weight
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.flag,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMealPlanItem(String mealName, String mealTime,
      {required int mealIndex, required String mealDetails}) {
    return Column(
      children: [
        _buildMealTile(
          mealName,
          mealDetails,
          mealTime,
          mealIndex,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMealTile(String mealName, String mealText, String mealTime,
      int mealIndex) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: Colors.white.withOpacity(0.1), // Set a semi-transparent background
        leading: Container(
          // Add a glass-like blur effect
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0.2),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.restaurant,
                  size: 32,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          mealName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          mealTime,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealText,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: mealCompletion[mealIndex]
                          ? null
                          : () {
                        updateProgress(mealIndex, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mealCompletion[mealIndex]
                            ? Colors.grey
                            : Colors.green,
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        'Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: mealCompletion[mealIndex]
                          ? () {
                        updateProgress(mealIndex, false);
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mealCompletion[mealIndex]
                            ? Colors.red
                            : Colors.grey,
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        'Undo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



