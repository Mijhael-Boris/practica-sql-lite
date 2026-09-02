import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/habit.dart';
import '../../models/habit_log.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habit_tracker.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla de hábitos
    await db.execute('''
      CREATE TABLE habits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        icon TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Tabla de registros diarios
    await db.execute('''
      CREATE TABLE habit_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId INTEGER NOT NULL,
        date TEXT NOT NULL,
        completed INTEGER NOT NULL,
        FOREIGN KEY (habitId) REFERENCES habits(id) ON DELETE CASCADE
      )
    ''');

    // Insertar datos de prueba
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    final now = DateTime.now();
    // Insertar 3 hábitos de ejemplo
    final habits = [
      Habit(name: 'Hacer ejercicio', description: '30 min de cardio', icon: '🏃', createdAt: now),
      Habit(name: 'Leer', description: 'Leer 20 páginas', icon: '📚', createdAt: now),
      Habit(name: 'Meditar', description: '10 min de mindfulness', icon: '🧘', createdAt: now),
    ];

    for (var habit in habits) {
      int id = await db.insert('habits', habit.toMap());
      // Insertar algunos logs de prueba para los últimos 7 días
      for (int i = 0; i < 7; i++) {
        final date = now.subtract(Duration(days: i));
        final completed = i % 2 == 0; // alternar completado
        await db.insert('habit_logs', {
          'habitId': id,
          'date': date.toIso8601String(),
          'completed': completed ? 1 : 0,
        });
      }
    }
  }

  // ---- CRUD Hábitos ----
  Future<int> insertHabit(Habit habit) async {
    Database db = await database;
    return await db.insert('habits', habit.toMap());
  }

  Future<List<Habit>> getHabits() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  Future<int> updateHabit(Habit habit) async {
    Database db = await database;
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    Database db = await database;
    return await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  // ---- CRUD Logs ----
  Future<int> insertLog(HabitLog log) async {
    Database db = await database;
    return await db.insert('habit_logs', log.toMap());
  }

  Future<List<HabitLog>> getLogsForHabit(int habitId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habit_logs',
      where: 'habitId = ?',
      whereArgs: [habitId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => HabitLog.fromMap(maps[i]));
  }

  Future<int> updateLog(HabitLog log) async {
    Database db = await database;
    return await db.update(
      'habit_logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<int> deleteLog(int id) async {
    Database db = await database;
    return await db.delete('habit_logs', where: 'id = ?', whereArgs: [id]);
  }

  // Obtener log de un día específico para un hábito (para toggle)
  Future<HabitLog?> getLogForDate(int habitId, DateTime date) async {
    Database db = await database;
    final dateStr = date.toIso8601String().split('T').first;
    final List<Map<String, dynamic>> maps = await db.query(
      'habit_logs',
      where: 'habitId = ? AND date LIKE ?',
      whereArgs: [habitId, '$dateStr%'],
    );
    if (maps.isNotEmpty) {
      return HabitLog.fromMap(maps.first);
    }
    return null;
  }
}