// Package imports:
import 'package:audioplayers/audioplayers.dart';

/// A looping asset whose volume and rate can be changed cheaply: values that
/// barely moved are not sent to the platform. Failures leave it silent.
class LoopPlayer {
  LoopPlayer(this.asset);

  final String asset;
  final AudioPlayer _player = AudioPlayer();
  bool _ready = false;
  double _volume = -1;
  double _rate = 1;

  Future<void> start({double volume = 0}) async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource(asset), volume: volume);
      _volume = volume;
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  void set({double? volume, double? rate}) {
    if (!_ready) return;
    if (volume != null &&
        ((volume - _volume).abs() > 0.02 || (volume == 0 && _volume != 0))) {
      _volume = volume;
      _player.setVolume(volume).ignore();
    }
    if (rate != null && (rate - _rate).abs() > 0.015) {
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
    } catch (_) {}
  }
}
