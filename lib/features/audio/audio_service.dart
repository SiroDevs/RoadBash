// Package imports:
import 'package:audioplayers/audioplayers.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'audio_catalog.dart';
import 'loop_player.dart';

@lazySingleton
class AudioService {
  LoopPlayer? _music;
  MusicTrack? _track;

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

  void setMusicVolume(double volume) => _music?.set(volume: volume);

  void pause() => _music?.pause();

  void resume() => _music?.resume();

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
