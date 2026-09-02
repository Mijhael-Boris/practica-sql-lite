import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presenters/habit_presenter.dart';
import 'presenters/settings_presenter.dart';
import 'presenters/sensor_presenter.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/sensor_screen.dart';
import 'views/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitPresenter()..loadHabits()),
        ChangeNotifierProvider(create: (_) => SettingsPresenter()..loadSettings()),
        ChangeNotifierProvider(create: (_) => SensorPresenter()),
      ],
      child: Consumer<SettingsPresenter>(
        builder: (context, settingsPresenter, child) {
          return MaterialApp(
            title: 'Habit Tracker',
            theme: settingsPresenter.settings.darkMode
                ? ThemeData.dark(useMaterial3: true)
                : ThemeData.light(useMaterial3: true),
            home: const MainScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas que se mostrarán en cada pestaña
  static const List<Widget> _screens = [
    HomeScreen(),
    SensorScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.sensors),
            label: 'Sensor',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}