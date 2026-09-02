import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presenters/sensor_presenter.dart';

class SensorScreen extends StatelessWidget {
  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SensorPresenter>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor de Movimiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mueve el teléfono para contar pasos'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (presenter.errorMessage.isNotEmpty)
                Card(
                  color: Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      '⚠️ ${presenter.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Pasos contados',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${presenter.stepCount}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (presenter.lastEvent != null)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Valores del acelerómetro',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSensorValue('X', presenter.lastEvent!.x),
                            _buildSensorValue('Y', presenter.lastEvent!.y),
                            _buildSensorValue('Z', presenter.lastEvent!.z),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: presenter.resetStepCount,
                icon: const Icon(Icons.refresh),
                label: const Text('Reiniciar contador'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorValue(String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(fontSize: 16),
        ),
        const Text('m/s²', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}