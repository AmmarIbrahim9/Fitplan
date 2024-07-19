import 'package:fitplanv_1/bmiCalculator.dart';
import 'package:fitplanv_1/settings.dart';
import 'package:fitplanv_1/social%20feed.dart';
import 'package:fitplanv_1/user_profile.dart';
import 'package:fitplanv_1/userinput/userinput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


import 'TodoGroccery.dart';
import 'calender.dart';
import 'chatbot.dart';
import 'forgotpasswordpage.dart';
import 'homepage.dart';
import 'login.dart'; // Assuming this is the correct import path for your login screen
import 'subscription.dart'; // Import your new subscription page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Navbar());
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isSubscribed = false;

  bool get isDarkMode => _isDarkMode;

  bool get isSubscribed => _isSubscribed;

  ThemeMode getCurrentTheme() {
    return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setSubscriptionStatus(bool status) {
    _isSubscribed = status;
    notifyListeners();
  }
}

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.getCurrentTheme(),
            darkTheme: ThemeData.dark(),
            theme: ThemeData.light(),
            home: AuthChecker(),
          );
        },
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return FirstScreen();
    } else {
      return MyHomePage();
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _selectedIndex = 1; // Default selected index (for Home page)

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Animate to the new index
    _animateToIndex(index);
  }

  void _animateToIndex(int index) {
    _animationController.animateTo(index * 1.0 / 6); // Updated to 6 items
  }

  void _showSubscriptionPrompt(
      BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Subscribe Now'),
        content: Text('Subscribe now to unlock the Chat bot feature.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionPage(),
                ),
              );
              if (result == true) {
                themeProvider.setSubscriptionStatus(true);
              }
            },
            child: Text('Subscribe'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<Widget> _pages = [
      themeProvider.isSubscribed ? ChatApp() : SubscriptionPromptPage(),
      FitPlanHomePage(),
      MealPlansPage(),
      GroceryListPage(),
      SocialFeedPage(), // New social feed page
      SettingsPage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: 'pages_transition',
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: _selectedIndex *
                (MediaQuery.of(context).size.width / 6), // Updated to 6 items
            bottom: 0,
            child: Container(
              width:
              MediaQuery.of(context).size.width / 6, // Updated to 6 items
              height: 5,
              color: Colors.green,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_outlined, size: 30),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today, size: 30),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart, size: 30),
            label: 'Grocery',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people, size: 30),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle, size: 30),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0 && !themeProvider.isSubscribed) {
            _showSubscriptionPrompt(context, themeProvider);
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class SubscriptionPromptPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Subscribe now to unlock this feature.'),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          SettingsSection(
            title: 'Account',
            settings: [
              SettingsItem(
                icon: Icons.person,
                title: 'Profile',
                subtitle: 'Edit your profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInput(),
                    ),
                  );
                },
              ),
              SettingsItem(
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Forgetpasswordpage(),
                    ),
                  );
                },
              ),
              SettingsItem(
                icon: Icons.payment,
                title: 'Subscription',
                subtitle: 'Manage your subscription',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscriptionPage(),
                    ),
                  );
                },
              ),
              SettingsItem(
                icon: Icons.exit_to_app,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstScreen(),
                      ),
                    );
                  } catch (e) {
                    print('Error signing out: $e');
                  }
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Preferences',
            settings: [
              SettingsItem(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Enable dark mode',
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: themeProvider.isSubscribed
                      ? (bool value) {
                    themeProvider.toggleTheme();
                  }
                      : null,
                  activeColor: Colors.blue,
                ),
                onTap: () {
                  if (!themeProvider.isSubscribed) {
                    _showSubscriptionPrompt(context, themeProvider);
                  }
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Calculator',
            settings: [
              SettingsItem(
                icon: Icons.calculate_outlined,
                title: 'BMI calculator',
                subtitle: 'Calculate your bmi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BMICalculator(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSubscriptionPrompt(
      BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Subscribe Now'),
        content: Text('Subscribe now to unlock the Dark Mode feature.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionPage(),
                ),
              );
              if (result == true) {
                themeProvider.setSubscriptionStatus(true);
              }
            },
            child: Text('Subscribe'),
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsItem> settings;

  SettingsSection({required this.title, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...settings,
      ],
    );
  }
}


