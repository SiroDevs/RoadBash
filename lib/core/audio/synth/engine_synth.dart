// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_soloud/flutter_soloud.dart';

// Project imports:
import 'engine_voice.dart';
import 'engine_wave.dart';
import 'soloud_loop.dart';

/// The synthesized engine: three generated loops played together through
/// SoLoud, with their volume and pitch driven by [EngineVoice].
class EngineSynth {
  EngineSynth() {
    final loops = EngineWave.loops;
    _voice = EngineVoice([for (final l in loops) l.baseHz]);
    _layers = [
      for (final l in loops)
        SoloudLoop('engine-${l.baseHz.round()}hz.wav', l.wav),
    ];
  }

  /// Seconds between updates. SoLoud calls are cheap, so this can be short.
  static const double _tick = 0.02;

  /// Extra gain on top of the engine slider, so the engine sits above the
  /// music. Each layer is still clamped at full volume.
  static const double boost = 1.6;

  late final EngineVoice _voice;
  late final List<SoloudLoop> _layers;
  double _acc = 0;
  double _logClock = 0;

  Future<void> start() async {
    try {
      if (!SoLoud.instance.isInitialized) await SoLoud.instance.init();
    } catch (e) {
      debugPrint('[engine] SoLoud init failed: $e');
      return;
    }
    await Future.wait(_layers.map((l) => l.start()));
  }

  void update(
    double dt, {
    required double volume,
    required double rpm,
    required int gear,
    required bool throttle,
    required bool brake,
    required bool locked,
    required bool stopped,
  }) {
    _acc += dt;
    if (_acc < _tick) return;
    final step = _acc;
    _acc = 0;
    _voice.update(
      step,
      rpm: rpm,
      gear: gear,
      throttle: throttle,
      brake: brake,
      locked: locked,
      stopped: stopped,
    );
    if (kDebugMode && (_logClock += step) >= 1.0) {
      _logClock = 0;
      debugPrint(
        '[engine] in=${volume.toStringAsFixed(2)} thr=$throttle '
        'rpm=${rpm.toStringAsFixed(2)} gear=$gear '
        'vol=${_voice.volumes.map((v) => v.toStringAsFixed(2))} '
        'speed=${_voice.rates.map((r) => r.toStringAsFixed(2))}',
      );
    }
    for (var i = 0; i < _layers.length; i++) {
      _layers[i].set(
        volume: math.min(
          1.0,
          math.max(0.0, volume * boost * _voice.volumes[i]),
        ),
        speed: _voice.rates[i],
      );
    }
  }

  void pause() {
    for (final l in _layers) {
      l.pause();
    }
  }

  void resume() {
    for (final l in _layers) {
      l.resume();
    }
  }

  Future<void> dispose() => Future.wait(_layers.map((l) => l.dispose()));
}
