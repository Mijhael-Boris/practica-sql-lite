class UserSettings {
  final bool darkMode;
  final bool reminderEnabled;
  final String? reminderTime; // "HH:mm"

  UserSettings({
    required this.darkMode,
    required this.reminderEnabled,
    this.reminderTime,
  });

  // Convertir a/desde mapa para SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'reminderEnabled': reminderEnabled,
      'reminderTime': reminderTime,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      darkMode: map['darkMode'] ?? false,
      reminderEnabled: map['reminderEnabled'] ?? false,
      reminderTime: map['reminderTime'],
    );
  }
}