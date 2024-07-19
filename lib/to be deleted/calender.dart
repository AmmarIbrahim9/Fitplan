// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'dart:async';
//
// import 'package:provider/provider.dart';
//
// class ThemeProvider extends ChangeNotifier {
//   bool _isDarkMode = false;
//
//   bool get isDarkMode => _isDarkMode;
//
//   ThemeMode getCurrentTheme() {
//     return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
//   }
//
//   void toggleTheme() {
//     _isDarkMode = !_isDarkMode;
//     notifyListeners();
//   }
// }
//
// class Calender extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ThemeProvider(),
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           return MaterialApp(
//             themeMode: themeProvider.getCurrentTheme(),
//             darkTheme: ThemeData.dark().copyWith(
//               scaffoldBackgroundColor: Colors.grey[900],
//               primaryColor: Colors.green,
//               hintColor: Colors.greenAccent,
//               textTheme: TextTheme(
//                 bodyMedium: TextStyle(color: Colors.white),
//                 titleLarge: TextStyle(color: Colors.white),
//                 titleMedium: TextStyle(color: Colors.white),
//               ),
//             ),
//             theme: ThemeData.light(),
//             home: CalendarApp(),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class CalendarApp extends StatefulWidget {
//   @override
//   _CalendarAppState createState() => _CalendarAppState();
// }
//
// class _CalendarAppState extends State<CalendarApp> {
//   late DateTime currentDate;
//   late int selectedYear;
//   late int selectedMonth;
//   Timer? _timer;
//   DateTime? selectedDate; // Variable to track the selected date
//
//   // Map to track checkbox states for each date
//   late Map<DateTime, Map<String, bool>> mealOptions = {};
//
//   @override
//   void initState() {
//     super.initState();
//     currentDate = DateTime.now();
//     selectedYear = currentDate.year;
//     selectedMonth = currentDate.month;
//     selectedDate = currentDate; // Initialize selectedDate with currentDate
//     startUpdating();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   void startUpdating() {
//     _timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
//       setState(() {
//         currentDate = DateTime.now();
//         selectedYear = currentDate.year;
//         selectedMonth = currentDate.month;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final daysOfWeek = <String>[
//       'Mon',
//       'Tue',
//       'Wed',
//       'Thu',
//       'Fri',
//       'Sat',
//       'Sun'
//     ]; // List of days of the week
//
//     final startingDayOfWeek =
//         DateTime(selectedYear, selectedMonth, 1).weekday - 1;
//     final adjustedDaysOfWeek = [
//       ...daysOfWeek.sublist(startingDayOfWeek),
//       ...daysOfWeek.sublist(0, startingDayOfWeek),
//     ];
//
//     return Scaffold(
//       backgroundColor: Theme
//           .of(context)
//           .scaffoldBackgroundColor,
//       body: GlassmorphicContainer(
//         width: double.infinity,
//         height: double.infinity,
//         borderRadius: 30,
//         linearGradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.grey.shade200.withOpacity(0.2),
//             Colors.grey.shade100.withOpacity(0.2),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.arrow_back_ios),
//                         onPressed: () {
//                           setState(() {
//                             selectedMonth--;
//                             if (selectedMonth <= 0) {
//                               selectedMonth = 12;
//                               selectedYear--;
//                             }
//                           });
//                         },
//                       ),
//                       Text(
//                         '${_getMonthName(selectedMonth)} $selectedYear',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.arrow_forward_ios),
//                         onPressed: () {
//                           setState(() {
//                             selectedMonth++;
//                             if (selectedMonth > 12) {
//                               selectedMonth = 1;
//                               selectedYear++;
//                             }
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: adjustedDaysOfWeek
//                         .map(
//                           (day) =>
//                           Text(
//                             day,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                     )
//                         .toList(),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: GridView.builder(
//                 padding: EdgeInsets.all(20),
//                 itemCount: getDaysInMonth(selectedMonth, selectedYear),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 7,
//                   mainAxisSpacing: 10,
//                   crossAxisSpacing: 10,
//                   childAspectRatio: 1.0,
//                 ),
//                 itemBuilder: (context, index) {
//                   final dayNumber = index + 1;
//                   final isCurrentDay = dayNumber == currentDate.day &&
//                       selectedMonth == currentDate.month &&
//                       selectedYear == currentDate.year;
//                   final isPastDay =
//                   DateTime(selectedYear, selectedMonth, dayNumber)
//                       .isBefore(DateTime(currentDate.year,
//                       currentDate.month, currentDate.day));
//
//                   final isSelected = selectedDate != null &&
//                       dayNumber == selectedDate!.day &&
//                       selectedMonth == selectedDate!.month &&
//                       selectedYear == selectedDate!.year;
//
//                   // Check if all meal options are selected for the day
//                   bool allSelected = mealOptions[DateTime(
//                       selectedYear, selectedMonth, dayNumber)]
//                       ?.values
//                       .every((element) => element) ??
//                       false;
//
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedDate =
//                             DateTime(selectedYear, selectedMonth, dayNumber);
//                       });
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: allSelected
//                             ? Colors.green[400]
//                             : (isSelected
//                             ? Colors.green[200]
//                             : Colors.transparent),
//                         // Updated to use transparent color
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(
//                         child: Text(
//                           '$dayNumber',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isSelected || isCurrentDay
//                                 ? Colors.redAccent
//                                 : isPastDay
//                                 ? Colors.grey[600]
//                                 : Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             if (selectedDate != null) _displayMealOptions(selectedDate!),
//           ],
//         ),
//       ),
//     );
//   }
//
//   int getDaysInMonth(int month, int year) {
//     switch (month) {
//       case 2:
//         return isLeapYear(year) ? 29 : 28;
//       case 4:
//       case 6:
//       case 9:
//       case 11:
//         return 30;
//       default:
//         return 31;
//     }
//   }
//
//   String _getMonthName(int month) {
//     switch (month) {
//       case 1:
//         return 'January';
//       case 2:
//         return 'February';
//       case 3:
//         return 'March';
//       case 4:
//         return 'April';
//       case 5:
//         return 'May';
//       case 6:
//         return 'June';
//       case 7:
//         return 'July';
//       case 8:
//         return 'August';
//       case 9:
//         return 'September';
//       case 10:
//         return 'October';
//       case 11:
//         return 'November';
//       case 12:
//         return 'December';
//       default:
//         return '';
//     }
//   }
//
//   bool isLeapYear(int year) {
//     return ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);
//   }
//
//   Widget _displayMealOptions(DateTime date) {
//     return Container(
//       margin: EdgeInsets.all(20),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Meal Options for ${_getMonthName(date.month)} ${date.day}, ${date
//                 .year}',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 10),
//           _buildMealOptionTile(date, 'Breakfast'),
//           _buildMealOptionTile(date, 'Lunch'),
//           _buildMealOptionTile(date, 'Dinner'),
//         ],
//       ),
//     );
//
//
//   }
//
//   Widget _buildMealOptionTile(DateTime date, String mealType) {
//     final isSelected =
//         mealOptions[date] != null && mealOptions[date]![mealType] == true;
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: Theme
//             .of(context)
//             .cardColor,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ExpansionTile(
//         title: Text(
//           mealType,
//           style: TextStyle(fontSize: 18, color: Colors.black),
//         ),
//         trailing: Checkbox(
//           value: isSelected,
//           onChanged: (value) {
//             setState(() {
//               // Initialize mealOptions for the date if it's null
//               mealOptions[date] ??= {
//                 'Breakfast': false,
//                 'Lunch': false,
//                 'Dinner': false,
//               };
//
//               // Update the specific meal type value
//               mealOptions[date]![mealType] = value ?? false;
//             });
//           },
//           activeColor: Colors.green[400],
//           checkColor: Colors.white,
//         ),
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Text(
//               'Details for $mealType on ${_getMonthName(date.month)} ${date
//                   .day}, ${date.year}',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           SizedBox(height: 5),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et felis quis neque blandit consectetur. Nulla facilisi. Nullam sollicitudin neque vitae tortor posuere rutrum.',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // GlassmorphicContainer Widget for the glass effect with gradient border
// class GlassmorphicContainer extends StatelessWidget {
//   final double? width;
//   final double? height;
//   final double borderRadius;
//   final LinearGradient linearGradient;
//   final Widget child;
//
//   const GlassmorphicContainer({
//     Key? key,
//     this.width,
//     this.height,
//     required this.borderRadius,
//     required this.linearGradient,
//     required this.child,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(borderRadius),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           width: width,
//           height: height,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(borderRadius),
//             color: Theme
//                 .of(context)
//                 .colorScheme.background
//                 .withOpacity(0.2),
//             border: Border.all(
//               width: 1,
//               color: Colors.white.withOpacity(0.2),
//             ),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(borderRadius),
//               gradient: linearGradient,
//             ),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
