// Dart imports:
import 'dart:async';
import 'dart:math' as math;

// Project imports:
import '../../../domain/models/engine_flavour.dart';
import 'engine_synth.dart';

/// Plays a short engine sound sample for the sound settings.
class EnginePreview {
  static const double _dt = 0.016;
  static const double _throttleSecs = 3.4;
  static const double _totalSecs = 5.4;

  EngineSynth? _synth;
  Timer? _timer;
  int _token = 0;

  /// Plays a timed preview of an engine flavour.
  Future<void> play(EngineFlavour flavour, double volume) async {
    await stop();
    final token = _token;
    final synth = EngineSynth(flavour);
    _synth = synth;
    await synth.start();
    if (token != _token) {
      await synth.dispose();
      return;
    }
    var time = 0.0;
    var speed = 0.0;
    var rpm = 0.16;
    _timer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) {
        time += _dt;
        final throttle = time < _throttleSecs;
        speed = (speed + (throttle ? 1 / 4.0 : -1 / 3.0) * _dt)
            .clamp(0.0, 1.0)
            .toDouble();
        final gear = math.min(6, 1 + (speed * 6).floor());
        final inGear = (speed * 6 - (gear - 1)).clamp(0.0, 1.0).toDouble();
        final stopped = speed < 0.02;
        final target = (stopped && !throttle) ? 0.16 : 0.28 + 0.72 * inGear;
        rpm += (target - rpm) * math.min(1.0, _dt * 10);
        synth.update(
          _dt,
          volume: volume,
          rpm: rpm,
          gear: gear,
          throttle: throttle,
          brake: false,
          locked: false,
          stopped: stopped,
        );
        if (time >= _totalSecs) unawaited(stop());
      },
    );
  }

  /// Stops the preview.
  Future<void> stop() async {
    _token++;
    _timer?.cancel();
    _timer = null;
    final synth = _synth;
    _synth = null;
    await synth?.dispose();
  }
}
