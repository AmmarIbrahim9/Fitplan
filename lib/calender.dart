import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:table_calendar/table_calendar.dart'; // Import table_calendar package
import 'model/mysql.dart'; // Import your MySQLService

class MealPlansPage extends StatefulWidget {
  @override
  _MealPlansPageState createState() => _MealPlansPageState();
}

class _MealPlansPageState extends State<MealPlansPage> {
  final MySQLService _mySQLService = MySQLService();
  Map<DateTime, List<Map<String, dynamic>>> _dietPlans = {};
  bool _isLoading = true;
  String? _error;
  DateTime _selectedDay = DateTime.now(); // Selected day for displaying meal plans

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchDietPlans(_selectedDay);
  }

  Future<void> _fetchDietPlans(DateTime day) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _mySQLService.connect();
      List<Map<String, dynamic>> plans = await _mySQLService.fetchDietPlansForDay(day);
      setState(() {
        _dietPlans = {day: plans};
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error fetching diet plans: $e';
        _isLoading = false;
      });
    } finally {
      await _mySQLService.close();
    }
  }

  // Method to handle day selection in the calendar
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _fetchDietPlans(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('30-Day Meal Plans'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime(DateTime.now().year, DateTime.now().month, 1),
          lastDay: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onDaySelected: _onDaySelected,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(fontSize: 20),
            formatButtonDecoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            formatButtonTextStyle: TextStyle(color: Colors.white),
            formatButtonShowsNext: false,
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.green.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: _buildMealPlanList(),
        ),
      ],
    );
  }

  Widget _buildMealPlanList() {
    List<Map<String, dynamic>> plansForSelectedDay = _dietPlans[_selectedDay] ?? [];

    if (plansForSelectedDay.isEmpty) {
      return Center(
        child: Text(
          'No meal plans available for ${DateFormat('dd MMMM yyyy').format(_selectedDay)}.',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: plansForSelectedDay.length,
        itemBuilder: (context, index) {
          return _buildMealPlanCard(plansForSelectedDay[index]);
        },
      );
    }
  }

  Widget _buildMealPlanCard(Map<String, dynamic> mealPlan) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day: ${mealPlan['day']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            _buildMealTile('Breakfast', mealPlan['breakfast']),
            _buildMealTile('Lunch', mealPlan['lunch']),
            _buildMealTile('Dinner', mealPlan['dinner']),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTile(String mealType, String? mealDetails) {
    return ListTile(
      title: Text(
        mealType,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        mealDetails ?? 'No meal planned',
        style: TextStyle(fontSize: 14),
      ),
      trailing: Icon(Icons.restaurant_menu, color: Colors.green),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Meal Plans App',
    theme: ThemeData(
      primarySwatch: Colors.green,
      fontFamily: 'Roboto', // Example of setting custom font family
    ),
    home: MealPlansPage(),
  ));
}
