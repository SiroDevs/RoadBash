// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_soloud/flutter_soloud.dart';

/// A looping sound played through SoLoud.
class SoloudLoop {
  SoloudLoop(this.name, this.wav);

  final String name;
  final Uint8List wav;

  AudioSource? _source;
  SoundHandle? _handle;
  double _volume = -1;
  double _speed = 1;

  /// True once the loop has started.
  bool get ready => _handle != null;

  /// Loads and starts the loop.
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

  /// Sets the loop's volume and playback speed.
  void set({required double volume, required double speed}) {
    final handle = _handle;
    if (handle == null) return;
    if ((volume - _volume).abs() > 0.004 || (volume == 0 && _volume != 0)) {
      _volume = volume;
      SoLoud.instance.setVolume(handle, volume);
    }
    if ((speed - _speed).abs() > 0.002) {
      _speed = speed;
      SoLoud.instance.setRelativePlaySpeed(handle, speed);
    }
  }

  /// Pauses the loop.
  void pause() {
    final handle = _handle;
    if (handle != null) SoLoud.instance.setPause(handle, true);
  }

  /// Resumes the loop.
  void resume() {
    final handle = _handle;
    if (handle != null) SoLoud.instance.setPause(handle, false);
  }

  /// Stops the loop and releases its source.
  Future<void> dispose() async {
    final handle = _handle;
    final source = _source;
    _handle = null;
    _source = null;
    if (!SoLoud.instance.isInitialized) return;
    try {
      if (handle != null) await SoLoud.instance.stop(handle);
      if (source != null) await SoLoud.instance.disposeSource(source);
    } catch (_) {}
  }
}
