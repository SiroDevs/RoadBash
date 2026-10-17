// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:audioplayers/audioplayers.dart';

/// A looping sound whose volume and rate can be changed cheaply: values that
/// barely moved are not sent to the platform. Failures leave it silent (and
/// print why in debug builds).
///
/// The sound comes from an asset, or from in-memory WAV bytes (used by the
/// synthesized engine). Bytes are played from a temp file on every platform
/// except web, because BytesSource support varies between platforms.
class LoopPlayer {
  LoopPlayer(
    String asset, {
    this.volumeStep = 0.02,
    this.rateStep = 0.015,
  })  : _source = AssetSource(asset),
        _bytes = null;

  LoopPlayer.bytes(
    Uint8List wav, {
    this.volumeStep = 0.02,
    this.rateStep = 0.015,
  })  : _source = null,
        _bytes = wav;

  final Source? _source;
  final Uint8List? _bytes;
  final double volumeStep;
  final double rateStep;
  final AudioPlayer _player = AudioPlayer();
  File? _tempFile;
  bool _ready = false;
  double _volume = -1;
  double _rate = 1;

  Future<void> start({double volume = 0}) async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(await _resolve(), volume: volume);
      _volume = volume;
      _ready = true;
    } catch (e) {
      _ready = false;
      debugPrint('LoopPlayer could not start: $e');
    }
  }

  Future<Source> _resolve() async {
    final source = _source;
    if (source != null) return source;
    final bytes = _bytes!;
    if (kIsWeb) return BytesSource(bytes, mimeType: 'audio/wav');
    final file = File(
      '${Directory.systemTemp.path}/roadbash_loop_$hashCode.wav',
    );
    await file.writeAsBytes(bytes, flush: true);
    _tempFile = file;
    return DeviceFileSource(file.path, mimeType: 'audio/wav');
  }

  void set({double? volume, double? rate}) {
    if (!_ready) return;
    if (volume != null &&
        ((volume - _volume).abs() > volumeStep ||
            (volume == 0 && _volume != 0))) {
      _volume = volume;
      _player.setVolume(volume).ignore();
    }
    if (rate != null && (rate - _rate).abs() > rateStep) {
      _rate = rate;
      _player.setPlaybackRate(rate).ignore();
    }
  }

  void pause() {
    if (_ready) _player.pause().ignore();
  }

  void resume() {
    if (_ready) _player.resume().ignore();
  }

  Future<void> dispose() async {
    _ready = false;
    try {
      await _player.stop();
      await _player.dispose();
      await _tempFile?.delete();
    } catch (_) {}
  }
}
