// Project imports:
import '../../audio/audio_catalog.dart';
import '../../audio/loop_player.dart';

/// Plays the police siren while a cop is on the player's tail.
///
/// The siren starts with the first chase, gets louder as the cop closes in,
/// and is paused again when the chase ends.
class PoliceAudio {
  final LoopPlayer _loop = LoopPlayer(LoopSound.siren.asset);

  bool _started = false;
  bool _playing = false;

  /// Updates the siren: [active] while a cop chases, [level] is its volume.
  void update({required bool active, required double level}) {
    if (active) {
      if (!_started) {
        _started = true;
        _playing = true;
        _loop.start(volume: level).ignore();
        return;
      }
      if (!_loop.ready) return;
      if (!_playing) {
        _playing = true;
        _loop.resume();
      }
      _loop.set(volume: level);
    } else if (_playing && _loop.ready) {
      _playing = false;
      _loop.set(volume: 0);
      _loop.pause();
    }
  }

  /// Pauses the siren with the rest of the race audio.
  void pause() {
    if (_playing) _loop.pause();
  }

  /// Resumes the siren after a pause.
  void resume() {
    if (_playing) _loop.resume();
  }

  /// Releases the siren player.
  Future<void> dispose() => _loop.dispose();
}
