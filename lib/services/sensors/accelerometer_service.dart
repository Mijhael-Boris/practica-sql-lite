import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  final StreamController<AccelerometerEvent> _controller =
      StreamController<AccelerometerEvent>.broadcast();

  // Stream para que los Presenters escuchen
  Stream<AccelerometerEvent> get accelerometerStream => _controller.stream;

  bool _isListening = false;

  void startListening() {
    if (_isListening) return;
    _subscription = accelerometerEventStream().listen(
      (event) {
        _controller.add(event);
        // Aquí podrías implementar un contador de pasos simple:
        // detectar picos en la aceleración.
      },
      onError: (error) {
        // Manejar error (ej. sensor no disponible)
        _controller.addError('Sensor no disponible: $error');
      },
      cancelOnError: false,
    );
    _isListening = true;
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _isListening = false;
  }

  void dispose() {
    stopListening();
    _controller.close();
  }
}