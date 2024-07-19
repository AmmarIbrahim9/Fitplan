import 'package:flutter/material.dart';
import 'package:fitplanv_1/user_input.dart'; // Assuming this is the correct import path

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ThemeMode _themeMode = ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          SettingsSection(
            title: 'Account',
            settings: [
              SettingsItem(
                icon: Icons.person,
                title: 'Profile',
                subtitle: 'Edit your profile',
                onTap: () {
                },
              ),
              SettingsItem(
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () {},
              ),
            ],
          ),
          SettingsSection(
            title: 'Notifications',
            settings: [
              SettingsItem(
                icon: Icons.notifications,
                title: 'Notification Settings',
                subtitle: 'Manage your notifications',
                onTap: () {},
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
                  value: _themeMode == ThemeMode.dark,
                  onChanged: (bool value) {
                    setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  },
                  activeColor: Colors.blue,
                ),
              ),
              SettingsItem(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Select your language',
                onTap: () {},
              ),
            ],
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
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            children: settings,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(
        icon,
        size: 28,
        color: Colors.green,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
