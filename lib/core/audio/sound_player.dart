// Project imports:
import 'audio_catalog.dart';

/// Contract for playing sound effects and music.
abstract interface class SoundPlayer {
  void sfx(Sfx sfx);
  Future<void> playMusic(MusicTrack track);
}
