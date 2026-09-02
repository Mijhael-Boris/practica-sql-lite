import 'package:flutter/material.dart';
import '../models/user_settings.dart';
import '../services/storage/shared_prefs_helper.dart';

class SettingsPresenter extends ChangeNotifier {
  final SharedPrefsHelper _prefs = SharedPrefsHelper();
  UserSettings _settings = UserSettings(darkMode: false, reminderEnabled: false);

  UserSettings get settings => _settings;

  Future<void> loadSettings() async {
    _settings = await _prefs.loadSettings();
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _settings = UserSettings(
      darkMode: value,
      reminderEnabled: _settings.reminderEnabled,
      reminderTime: _settings.reminderTime,
    );
    await _prefs.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleReminder(bool value) async {
    _settings = UserSettings(
      darkMode: _settings.darkMode,
      reminderEnabled: value,
      reminderTime: _settings.reminderTime,
    );
    await _prefs.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setReminderTime(String time) async {
    _settings = UserSettings(
      darkMode: _settings.darkMode,
      reminderEnabled: _settings.reminderEnabled,
      reminderTime: time,
    );
    await _prefs.saveSettings(_settings);
    notifyListeners();
  }
}