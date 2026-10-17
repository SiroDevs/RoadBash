// Dart imports:
import 'dart:math' as math;

// Project imports:
import '../loop_player.dart';
import 'engine_voice.dart';
import 'engine_wave.dart';

/// The synthesized engine: three generated loops played together, with their
/// volume and pitch driven by [EngineVoice].
class EngineSynth {
  EngineSynth() {
    final loops = EngineWave.loops;
    _voice = EngineVoice([for (final l in loops) l.baseHz]);
    _players = [
      for (final l in loops)
        LoopPlayer.bytes(l.wav, volumeStep: 0.015, rateStep: 0.006),
    ];
  }

  /// Seconds between pushes to the audio players. Keeps platform calls down.
  static const double _tick = 0.033;

  /// Extra gain on top of the engine slider, so the engine sits above the
  /// music. Each player still clamps at full volume.
  static const double boost = 1.6;

  late final EngineVoice _voice;
  late final List<LoopPlayer> _players;
  double _acc = 0;

  Future<void> start() => Future.wait(_players.map((p) => p.start()));

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
    for (var i = 0; i < _players.length; i++) {
      _players[i].set(
        volume: math.min(
          1.0,
          math.max(0.0, volume * boost * _voice.volumes[i]),
        ),
        rate: _voice.rates[i],
      );
    }
  }

  void pause() {
    for (final p in _players) {
      p.pause();
    }
  }

  void resume() {
    for (final p in _players) {
      p.resume();
    }
  }

  Future<void> dispose() => Future.wait(_players.map((p) => p.dispose()));
}
