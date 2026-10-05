// Dart imports:
import 'dart:math' as math;

// Package imports:
import 'package:audioplayers/audioplayers.dart';

// Project imports:
import 'game_settings.dart';

/// Looping engine + tyre-squeal sounds. The engine is one recorded loop whose
/// playback rate follows the rpm, so it revs up and drops on each gear shift.
/// Audio is optional: any failure just leaves the game silent.
class GameAudio {
  GameAudio(this.settings);

  final GameSettings settings;
  final AudioPlayer _engine = AudioPlayer();
  final AudioPlayer _skid = AudioPlayer();

  bool _ready = false;
  double _acc = 0;
  double _skidLevel = 0;
  double _rate = 0;
  double _engineVol = -1;
  double _skidVol = -1;

  Future<void> start() async {
    try {
      await _engine.setReleaseMode(ReleaseMode.loop);
      await _skid.setReleaseMode(ReleaseMode.loop);
      await _engine.play(AssetSource('audio/engine.wav'), volume: 0);
      await _skid.play(AssetSource('audio/skid.wav'), volume: 0);
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  /// Call every frame; platform calls are throttled internally.
  void update(
    double dt, {
    required double rpm,
    required double load,
    required bool skidding,
  }) {
    if (!_ready) return;
    _skidLevel += ((skidding ? 1.0 : 0.0) - _skidLevel) * math.min(1.0, dt * 12);
    _acc += dt;
    if (_acc < 0.07) return;
    _acc = 0;

    final rate = 0.6 + 1.3 * rpm;
    final ev = _clamp01(settings.master * settings.engine * (0.35 + 0.65 * load));
    final sv = _clamp01(settings.master * settings.tyres * _skidLevel);

    if ((rate - _rate).abs() > 0.015) {
      _rate = rate;
      _engine.setPlaybackRate(rate).ignore();
    }
    if ((ev - _engineVol).abs() > 0.02) {
      _engineVol = ev;
      _engine.setVolume(ev).ignore();
    }
    if ((sv - _skidVol).abs() > 0.02) {
      _skidVol = sv;
      _skid.setVolume(sv).ignore();
    }
  }

  static double _clamp01(double v) => math.min(1.0, math.max(0.0, v));

  void pause() {
    if (!_ready) return;
    _engine.pause().ignore();
    _skid.pause().ignore();
  }

  void resume() {
    if (!_ready) return;
    _engine.resume().ignore();
    _skid.resume().ignore();
  }

  Future<void> dispose() async {
    _ready = false;
    for (final p in [_engine, _skid]) {
      try {
        await p.stop();
        await p.dispose();
      } catch (_) {}
    }
  }
}
