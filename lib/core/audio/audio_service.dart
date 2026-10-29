// Package imports:
import 'package:audioplayers/audioplayers.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'audio_catalog.dart';
import 'loop_player.dart';

/// Plays music and sound effects.
@lazySingleton
class AudioService {
  LoopPlayer? _music;
  MusicTrack? _track;

  /// Plays a music track, or only adjusts the volume if it already plays.
  Future<void> playMusic(MusicTrack track, double volume) async {
    if (_track == track) {
      _music?.set(volume: volume);
      return;
    }
    _track = track;
    final previous = _music;
    final next = LoopPlayer(track.asset);
    _music = next;
    await previous?.dispose();
    await next.start(volume: volume);
  }

  /// Sets the music volume.
  void setMusicVolume(double volume) => _music?.set(volume: volume);

  /// Pauses the music.
  void pause() => _music?.pause();

  /// Resumes the music.
  void resume() => _music?.resume();

  /// Plays a sound effect once.
  Future<void> playSfx(Sfx sfx, double volume) async {
    if (volume <= 0) return;
    final player = AudioPlayer();
    try {
      player.onPlayerComplete.first.then((_) => player.dispose());
      await player.play(AssetSource(sfx.asset), volume: volume);
    } catch (_) {
      await player.dispose();
    }
  }
}
