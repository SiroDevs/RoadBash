// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_soloud/flutter_soloud.dart';

/// One generated WAV loop played through SoLoud. Unlike a plain file player,
/// SoLoud loops gaplessly and lets the pitch (play speed) and volume change
/// instantly, with no limit on the speed range.
class SoloudLoop {
  SoloudLoop(this.name, this.wav);

  final String name;
  final Uint8List wav;

  AudioSource? _source;
  SoundHandle? _handle;
  double _volume = -1;
  double _speed = 1;

  bool get ready => _handle != null;

  Future<void> start() async {
    try {
      final so = SoLoud.instance;
      final source = await so.loadMem(name, wav, mode: LoadMode.memory);
      _source = source;
      _handle = so.play(source, volume: 0, looping: true);
      if (kDebugMode) debugPrint('[$name] playing');
    } catch (e) {
      _handle = null;
      debugPrint('[$name] could not start: $e');
    }
  }

  void set({required double volume, required double speed}) {
    final h = _handle;
    if (h == null) return;
    if ((volume - _volume).abs() > 0.004 || (volume == 0 && _volume != 0)) {
      _volume = volume;
      SoLoud.instance.setVolume(h, volume);
    }
    if ((speed - _speed).abs() > 0.002) {
      _speed = speed;
      SoLoud.instance.setRelativePlaySpeed(h, speed);
    }
  }

  void pause() {
    final h = _handle;
    if (h != null) SoLoud.instance.setPause(h, true);
  }

  void resume() {
    final h = _handle;
    if (h != null) SoLoud.instance.setPause(h, false);
  }

  Future<void> dispose() async {
    final h = _handle;
    final source = _source;
    _handle = null;
    _source = null;
    if (!SoLoud.instance.isInitialized) return;
    try {
      if (h != null) await SoLoud.instance.stop(h);
      if (source != null) await SoLoud.instance.disposeSource(source);
    } catch (_) {}
  }
}
