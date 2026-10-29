// Project imports:
import 'audio_catalog.dart';

abstract interface class SoundPlayer {
  void sfx(Sfx sfx);
  Future<void> playMusic(MusicTrack track);
}
