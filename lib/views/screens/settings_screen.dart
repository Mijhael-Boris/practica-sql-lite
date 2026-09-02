import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presenters/settings_presenter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SettingsPresenter>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Modo oscuro'),
                  subtitle: const Text('Activar tema oscuro en toda la app'),
                  value: presenter.settings.darkMode,
                  onChanged: presenter.toggleDarkMode,
                  secondary: const Icon(Icons.dark_mode),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Recordatorios'),
                  subtitle: const Text('Recibir notificaciones diarias'),
                  value: presenter.settings.reminderEnabled,
                  onChanged: presenter.toggleReminder,
                  secondary: const Icon(Icons.notifications),
                ),
                if (presenter.settings.reminderEnabled) ...[
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Hora del recordatorio'),
                    subtitle: Text(
                      presenter.settings.reminderTime ?? 'No establecida',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.timer),
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        final time =
                            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                        presenter.setReminderTime(time);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Información de la app'),
              subtitle: const Text('Versión 1.0.0'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Acerca de'),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Habit Tracker App'),
                        SizedBox(height: 8),
                        Text('Aplicación para seguimiento de hábitos'),
                        SizedBox(height: 8),
                        Text('Versión 1.0.0'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}