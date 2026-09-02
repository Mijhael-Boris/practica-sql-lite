import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/habit.dart';
import '../../presenters/habit_presenter.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar logs al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final presenter = Provider.of<HabitPresenter>(context, listen: false);
      presenter.loadLogsForHabit(widget.habit.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<HabitPresenter>(context);
    final habit = widget.habit;

    return Scaffold(
      appBar: AppBar(
        title: Text('${habit.icon} ${habit.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(habit.description, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Creado: ${_formatDate(habit.createdAt)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Progreso de los últimos 7 días',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: presenter.loadLogsForHabit(habit.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (presenter.logs.isEmpty) {
                    return const Center(
                      child: Text('No hay registros de este hábito'),
                    );
                  }
                  // Mostrar solo los últimos 7 días
                  final logs = presenter.logs.take(7).toList();
                  return ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            log.completed ? Icons.check_circle : Icons.circle_outlined,
                            color: log.completed ? Colors.green : Colors.grey,
                          ),
                          title: Text(_formatDate(log.date)),
                          trailing: Switch(
                            value: log.completed,
                            onChanged: (_) {
                              presenter.toggleHabitLog(habit.id!, log.date);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}