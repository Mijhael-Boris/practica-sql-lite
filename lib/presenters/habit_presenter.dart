import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../services/database/database_helper.dart';

class HabitPresenter extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<Habit> _habits = [];
  List<HabitLog> _logs = [];

  List<Habit> get habits => _habits;
  List<HabitLog> get logs => _logs;

  // Cargar todos los hábitos
  Future<void> loadHabits() async {
    _habits = await _db.getHabits();
    notifyListeners();
  }

  // Cargar logs para un hábito específico
  Future<void> loadLogsForHabit(int habitId) async {
    _logs = await _db.getLogsForHabit(habitId);
    notifyListeners();
  }

  // Agregar hábito
  Future<void> addHabit(Habit habit) async {
    await _db.insertHabit(habit);
    await loadHabits();
  }

  // Editar hábito
  Future<void> updateHabit(Habit habit) async {
    await _db.updateHabit(habit);
    await loadHabits();
  }

  // Eliminar hábito
  Future<void> deleteHabit(int id) async {
    await _db.deleteHabit(id);
    await loadHabits();
  }

  // Toggle completado de un día
  Future<void> toggleHabitLog(int habitId, DateTime date) async {
    final existing = await _db.getLogForDate(habitId, date);
    if (existing != null) {
      // Actualizar estado inverso
      final updated = HabitLog(
        id: existing.id,
        habitId: habitId,
        date: date,
        completed: !existing.completed,
      );
      await _db.updateLog(updated);
    } else {
      // Crear nuevo log
      final newLog = HabitLog(
        habitId: habitId,
        date: date,
        completed: true,
      );
      await _db.insertLog(newLog);
    }
    await loadLogsForHabit(habitId);
  }

  // Obtener porcentaje de completado para un hábito
  double getCompletionPercentage(int habitId) {
    if (_logs.isEmpty) return 0.0;
    final completed = _logs.where((log) => log.completed).length;
    return completed / _logs.length;
  }
}