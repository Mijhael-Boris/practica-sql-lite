import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math'; // 👈 Importante para sqrt()
import '../services/sensors/accelerometer_service.dart';

class SensorPresenter extends ChangeNotifier {
  final AccelerometerService _service = AccelerometerService();
  AccelerometerEvent? _lastEvent;
  String _errorMessage = '';
  int _stepCount = 0;
  final double _threshold = 2.0; // 👈 ahora es final

  AccelerometerEvent? get lastEvent => _lastEvent;
  String get errorMessage => _errorMessage;
  int get stepCount => _stepCount;

  SensorPresenter() {
    _listenToSensor();
  }

  void _listenToSensor() {
    _service.accelerometerStream.listen(
      (event) {
        _lastEvent = event;
        double magnitude = _computeMagnitude(event);
        if (magnitude > _threshold) {
          _stepCount++;
        }
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
    _service.startListening();
  }

  double _computeMagnitude(AccelerometerEvent event) {
    // Usamos sqrt() de dart:math
    return sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
  }

  void resetStepCount() {
    _stepCount = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}