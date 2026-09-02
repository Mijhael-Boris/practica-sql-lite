import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_settings.dart';
import 'dart:convert';

class SharedPrefsHelper {
  static const String _settingsKey = 'user_settings';

  Future<void> saveSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(settings.toMap());
    await prefs.setString(_settingsKey, json);
  }

  Future<UserSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_settingsKey);
    if (json != null) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return UserSettings.fromMap(map);
    }
    // valores por defecto
    return UserSettings(
      darkMode: false,
      reminderEnabled: false,
      reminderTime: null,
    );
  }
}