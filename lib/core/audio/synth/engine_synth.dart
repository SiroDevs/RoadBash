// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_soloud/flutter_soloud.dart';

// Project imports:
import '../../../domain/models/engine_flavour.dart';
import 'engine_tunes.dart';
import 'engine_voice.dart';
import 'engine_wave.dart';
import 'soloud_loop.dart';

class EngineSynth {
  EngineSynth(EngineFlavour flavour) {
    final loops = EngineWave.loopsFor(flavour);
    _voice = EngineVoice([
      for (final l in loops) l.baseHz,
    ], EngineTunes.of(flavour));
    _layers = [
      for (final l in loops)
        SoloudLoop('engine-${flavour.id}-${l.baseHz.round()}hz.wav', l.wav),
    ];
  }

  static const double _tick = 0.02;
  static const double boost = .8;

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
