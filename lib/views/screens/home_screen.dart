import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presenters/habit_presenter.dart';
import '../widgets/habit_card.dart';
import 'add_edit_habit_screen.dart';
import 'habit_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<HabitPresenter>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Hábitos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: presenter.loadHabits,
          ),
        ],
      ),
      body: FutureBuilder(
        future: presenter.loadHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (presenter.habits.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mood_bad, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay hábitos aún', style: TextStyle(fontSize: 18)),
                  Text('Presiona el botón + para agregar uno'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: presenter.habits.length,
            itemBuilder: (context, index) {
              final habit = presenter.habits[index];
              return HabitCard(
                habit: habit,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HabitDetailScreen(habit: habit),
                    ),
                  );
                },
                onEdit: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditHabitScreen(habit: habit),
                    ),
                  );
                  if (result == true) {
                    presenter.loadHabits();
                  }
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar hábito'),
                      content: const Text('¿Estás seguro de que quieres eliminar este hábito?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await presenter.deleteHabit(habit.id!);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditHabitScreen(),
            ),
          );
          if (result == true) {
            presenter.loadHabits();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}