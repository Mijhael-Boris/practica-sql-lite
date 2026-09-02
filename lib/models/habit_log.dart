class HabitLog {
  final int? id;
  final int habitId;
  final DateTime date;
  final bool completed;

  HabitLog({
    this.id,
    required this.habitId,
    required this.date,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date.toIso8601String(),
      'completed': completed ? 1 : 0,
    };
  }

  factory HabitLog.fromMap(Map<String, dynamic> map) {
    return HabitLog(
      id: map['id'],
      habitId: map['habitId'],
      date: DateTime.parse(map['date']),
      completed: map['completed'] == 1,
    );
  }
}