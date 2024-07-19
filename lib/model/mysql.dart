import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../printtablenametest.dart'; // Import FirestoreService

class MySQLService {
  late MySqlConnection _connection;
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> connect() async {
    final settings = ConnectionSettings(
      host: 'mydb.cpuqueima1b4.eu-north-1.rds.amazonaws.com',
      port: 3306,
      user: 'admin',
      password: 'ammar123258',
      db: 'fitplan',
    );

    _connection = await MySqlConnection.connect(settings);
  }

  Future<List<Map<String, dynamic>>> fetchDietPlans() async {
    try {
      String? tableName = await _firestoreService.getUserTable();

      if (tableName == null) {
        print('Unable to fetch tableName from FirestoreService.');
        return [];
      }

      final results = await _connection.query('''
        SELECT day, breakfast, lunch, dinner 
        FROM $tableName 
        ORDER BY day DESC
        LIMIT 30
      ''');

      return results.map((column) => {
        'day': column['day'],
        'breakfast': column['breakfast'],
        'lunch': column['lunch'],
        'dinner': column['dinner'],
      }).toList();
    } catch (e, stackTrace) {
      print('Error fetching diet plans: $e');
      print('StackTrace: $stackTrace');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchDietPlansForCurrentDay() async {
    try {
      String? tableName = await _firestoreService.getUserTable();

      if (tableName == null) {
        print('Unable to fetch tableName from FirestoreService.');
        return [];
      }

      // Get the current day as a two-digit string
      String formattedCurrentDay = DateFormat('dd').format(DateTime.now());

      final results = await _connection.query('''
      SELECT day, breakfast, lunch, dinner 
      FROM $tableName 
      WHERE day = ?
      ORDER BY day DESC
      LIMIT 30
    ''', [formattedCurrentDay]);

      return results.map((row) => {
        'day': row['day'],
        'breakfast': row['breakfast'],
        'lunch': row['lunch'],
        'dinner': row['dinner'],
      }).toList();
    } catch (e, stackTrace) {
      print('Error fetching diet plans for current day: $e');
      print('StackTrace: $stackTrace');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchDietPlansForDay(DateTime day) async {
    try {
      String? tableName = await _firestoreService.getUserTable();

      if (tableName == null) {
        print('Unable to fetch tableName from FirestoreService.');
        return [];
      }

      // Format the day parameter to match the format stored in the database
      String formattedDay = DateFormat('dd').format(day);

      final results = await _connection.query('''
      SELECT day, breakfast, lunch, dinner 
      FROM $tableName 
      WHERE day = ?
      ORDER BY day DESC
      LIMIT 30
    ''', [formattedDay]);

      return results.map((row) => {
        'day': row['day'],
        'breakfast': row['breakfast'],
        'lunch': row['lunch'],
        'dinner': row['dinner'],
      }).toList();
    } catch (e, stackTrace) {
      print('Error fetching diet plans for day $day: $e');
      print('StackTrace: $stackTrace');
      return [];
    }
  }

  Future<void> close() async {
    await _connection.close();
  }
}
